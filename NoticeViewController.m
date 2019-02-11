//
//  NoticeViewController.m
//  Lookey
//
//  Created by 준구 황 on 2015. 6. 2..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "NoticeViewController.h"

#import "NoticeTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

const int HEIGHT_DEFAULT_NOTICE = 66;
const int HEIGHT_FULL_NOTICE = 300;
const int HEIGHT_NOT_IMAGE_NOTICE = 149;

const int TABLE_LIMIT_COUNT = 10;

@interface NoticeViewController () <NoticeTableDelegate> {
	CGRect _originalTitleFrame;
	CGRect _originalContentFrame;
	int _offset;
	int _limit;
}

@property (nonatomic, strong) NSMutableArray *noticeList;

@end

@implementation NoticeViewController

@synthesize noticeList;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.noticeList = [NSMutableArray array];
	_notiTableView.tableFooterView = [self getTableFooterView];
	[self requestGetNotice];
}


- (UIView*) getTableFooterView {
	UIView* footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
	footerView.backgroundColor = [UIColor clearColor];
	
	UIButton *moreBtn = [UIButton buttonWithType: UIButtonTypeCustom];
	moreBtn.frame = CGRectMake(141, 7, 37, 37);
	[moreBtn setImage: [UIImage imageNamed: @"btn_more_notice.png"] forState: UIControlStateNormal];
	[moreBtn addTarget: self action: @selector(moreBtnPressed:) forControlEvents: UIControlEventTouchUpInside];
	[footerView addSubview: moreBtn];
	return footerView;
}


- (void) requestGetNotice {
	AppDataManager *adm = [AppDataManager appDataManager];
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_get_notice.php", adm.SERVER_IP];
	NSMutableDictionary *params = [NSMutableDictionary new];
	
	params[CUSTOMER_CODE]	= [adm loadData: CUSTOMER_CODE];
	params[LANGUAGE_CODE]	= [CommonUtils getLanguageCode];
	params[@"offset"]		= [NSString stringWithFormat: @"%d", _offset];
	params[@"limit"]		= [NSString stringWithFormat: @"%d", TABLE_LIMIT_COUNT];
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
	[LoadingHUD show];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[LoadingHUD dismiss];
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
		NSNumber *results = response[RESULTS];
		if ([results intValue] == 1) {
			
			NSArray *noticeRawList = response[@"notices"];
			for (NSDictionary *noticeInfo in noticeRawList) {
				NSMutableDictionary *mutableNoticeInfo = [NSMutableDictionary dictionaryWithDictionary: noticeInfo];
				mutableNoticeInfo[@"selected"] = @"0";
				[noticeList addObject: mutableNoticeInfo];
			}
			
			_offset += TABLE_LIMIT_COUNT;
			if ([response[@"count"] intValue] >= TABLE_LIMIT_COUNT) {
				_notiTableView.tableFooterView = [self getTableFooterView];
			} else {
				_notiTableView.tableFooterView = nil;
			}
		} else {
			_notiTableView.tableFooterView = nil;
		}
		
		[self.notiTableView reloadData];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"requestGetNotice Failed : %@", [error localizedDescription]);
		
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
	}];
	[operation start];
}


#pragma mark - IBAction

- (IBAction)backBtnPressed:(id)sender {
	[self dismissViewControllerAnimated: YES completion: nil];
}


- (void) moreBtnPressed: (id) sender {
	[self requestGetNotice];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView: (UITableView*) tableView
 numberOfRowsInSection: (NSInteger) section {
	return noticeList.count;
}


- (UITableViewCell*) tableView: (UITableView*) tableView
		 cellForRowAtIndexPath: (NSIndexPath*) indexPath {
	NSString *cellIdentifier = @"NoticeTableViewCell";
	NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if (!cell) {
		cell = [[NoticeTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
										  reuseIdentifier: cellIdentifier];
	}
	if (noticeList.count <= indexPath.row)
		return cell;
	
	if (_originalTitleFrame.size.width == 0) {
		_originalTitleFrame = cell.noticeTitleLabel.frame;
	}
	
	if (_originalContentFrame.size.width == 0) {
		_originalContentFrame = cell.noticeContentLabel.frame;
	}
	
	NSDictionary *noticeInfo = noticeList[indexPath.row];
	cell.delegate = self;
	cell.index = (int) indexPath.row;
	
	cell.noticeTitleLabel.frame = _originalTitleFrame;
	cell.noticeTitleLabel.text = noticeInfo[@"not_title"];
	[cell.noticeTitleLabel sizeToFit];
	
	// 00:00:00 제거
	NSString *date = noticeInfo[@"not_date"];
	date = [date stringByReplacingOccurrencesOfString: @"00:00:00" withString: @""];
	cell.noticeDateLabel.text = date;
	
	cell.noticeContentLabel.frame = _originalContentFrame;
	NSString *content = noticeInfo[@"not_content"];
	content = [content stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
	cell.noticeContentLabel.text = content;
	[cell.noticeContentLabel sizeToFit];
	
	if ([noticeInfo[@"not_image"] isEqualToString: @""]) {
		cell.noticeContentImageView.hidden = YES;
		[CommonUtils changeFrame: cell.imageBottomLineView what: 1, @"y", 79];
	} else {
		cell.noticeContentImageView.hidden = NO;
		[cell.noticeContentImageView sd_setImageWithURL: [NSURL URLWithString: noticeInfo[@"not_image"]]];
		[CommonUtils changeFrame: cell.imageBottomLineView what: 1, @"y", 199];
	}
	
	NSString *selected = noticeInfo[@"selected"];
	if ([selected isEqualToString: @"0"]) {
		cell.noticeDetailView.hidden = YES;
		cell.noticeBtn.selected = NO;
	} else {
		cell.noticeDetailView.hidden = NO;
		cell.noticeBtn.selected = YES;
	}
	return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *noticeInfo = noticeList[indexPath.row];
	if ([noticeInfo[@"selected"] isEqualToString: @"0"])
		return HEIGHT_DEFAULT_NOTICE;
	if ([noticeInfo[@"not_image"] isEqualToString: @""])
		return HEIGHT_NOT_IMAGE_NOTICE;
	return HEIGHT_FULL_NOTICE;
}

#pragma mark - NoticeTableDelegate

- (void) selectNotice: (int) index bSelected: (BOOL) bSelected {
	NSMutableDictionary *noticeInfo = noticeList[index];
	NSString *selected = noticeInfo[@"selected"];
	if ([selected isEqualToString: @"0"]) {
		noticeInfo[@"selected"] = @"1";
	} else {
		noticeInfo[@"selected"] = @"0";
	}
	noticeList[index] = noticeInfo;
	
	[self.notiTableView reloadData];
}

@end

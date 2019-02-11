//
//  PhotoNormalTypeViewController.m
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 6..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "PhotoNormalTypeViewController.h"

#import "LLSimpleCamera.h"
#import "LoadingHUD.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "AppDataManager.h"
#import "MainPanelController.h"
#import "GalleryDetailViewController.h"
#import "LookeyWebViewController.h"

#import <MediaPlayer/MediaPlayer.h>

typedef enum {
	kBtnTag_Intro = 1000,
	kBtnTag_Album,
	kBtnTag_Video,
	kBtnTag_Shopping,
	kBtnTag_Location,
	kBtnTag_Reply,
	kBtnTag_Contacts
} eBtnTagType;

@interface PhotoNormalTypeViewController () {
	BOOL _bWeddingType;
}

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (nonatomic, assign) int selectedMenu;

@end

@implementation PhotoNormalTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	
	self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
	self.camera.useDeviceOrientation = YES;
	self.camera.tapToFocus = NO;
	
	// attach to a view controller
	CGRect screenRect = [[UIScreen mainScreen] bounds];	
	[self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
	
	// read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
	// you probably will want to set this to YES, if you are going view the image outside iOS.
	self.camera.fixOrientationAfterCapture = NO;
	
	_bWeddingType = [_normalTypeData[@"reg_mode"] intValue] == 3;
	
	[self.view addSubview: self.takePictureBtn];
	[self relocateShareButtons: _normalTypeData];
	[self relocateBottomMenus: _normalTypeData];
	
	[self.view addSubview: self.contentView];
	[self.contentView.layer setCornerRadius: 10.0f];
	[self.contentView.layer setMasksToBounds: YES];
	
	[self.view addSubview: self.videoView];
	[self.videoView.layer setCornerRadius: 10.0f];
	[self.videoView.layer setMasksToBounds: YES];
	[self selectMenu: [_normalTypeData[@"reg_ltype"] intValue]];
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.camera stop];
}


- (void) relocateShareButtons: (NSDictionary*) data {
	int btnGap = 55;
	
	// Web Link
	if ( (!_bWeddingType && [data[@"reg_link_web"] intValue] == 1)
		|| (_bWeddingType && [data[@"reg_web_url"] length] > 0) ) {
		[self.view addSubview: self.shareWebLinkBtn];
	} else {
		[CommonUtils changeFrame: self.shareYoutubeBtn what: 1, @"+x", btnGap];
		[CommonUtils changeFrame: self.shareFacebookBtn what: 1, @"+x", btnGap];
		[CommonUtils changeFrame: self.shareTwitterBtn what: 1, @"+x", btnGap];
	}
	
	// Youtube
	if ( (!_bWeddingType && [data[@"reg_link_youtube"] intValue] == 1)
		|| (_bWeddingType && [data[@"reg_youtube_url"] length] > 0) ) {
		[self.view addSubview: self.shareYoutubeBtn];
	} else {
		[CommonUtils changeFrame: self.shareFacebookBtn what: 1, @"+x", btnGap];
		[CommonUtils changeFrame: self.shareTwitterBtn what: 1, @"+x", btnGap];
	}
	
	// Facebook
	if ( (!_bWeddingType && [data[@"reg_link_facebook"] intValue] == 1)
		|| (_bWeddingType && [data[@"reg_facebook_url"] length] > 0) ) {
		[self.view addSubview: self.shareFacebookBtn];
	} else {
		[CommonUtils changeFrame: self.shareTwitterBtn what: 1, @"+x", btnGap];
	}

	// Twitter
	if ( (!_bWeddingType && [data[@"reg_link_twitter"] intValue] == 1)
		|| (_bWeddingType && [data[@"reg_twitter_url"] length] > 0) ) {
		[self.view addSubview: self.shareTwitterBtn];
	}
}


- (void) relocateBottomMenus: (NSDictionary*) data {
	if (!_bWeddingType) {
		self.menuIntroBtn.hidden = ([data[@"reg_link_intro"] intValue] == 0);
		self.menuAlbumBtn.hidden = ([data[@"reg_link_photo"] intValue] == 0);
		self.menuVideoBtn.hidden = ([data[@"reg_link_video"] intValue] == 0);
		self.menuLocationBtn.hidden = ([data[@"reg_link_location"] intValue] == 0);
		self.menuShoppingBtn.hidden = ([data[@"reg_link_shopping"] intValue] == 0);
	} else {
		self.menuIntroBtn.hidden = (!data[@"int_name"] || [data[@"int_name"] isEqualToString: @""]);
		self.menuAlbumBtn.hidden = ([data[@"count_photo"] intValue] == 0);
		self.menuVideoBtn.hidden = (!data[@"video_file"] && !data[@"reg_youtube"]);
		self.menuLocationBtn.hidden = ([data[@"count_location"] intValue] == 0);
		self.menuShoppingBtn.hidden = YES;
	}
	self.menuContactsBtn.hidden = [data[@"int_phone"] isEqualToString: @""];
	
	const int BUTTON_GAP = 45;
	for (int i = kBtnTag_Intro ; i <= kBtnTag_Contacts ; i++) {
		UIView *view = [self.view viewWithTag: i];
		if (view.hidden) {
			for (int j = i + 1 ; j <= kBtnTag_Contacts ; j++) {
				UIView *view = [self.view viewWithTag: j];
				CGRect frame = view.frame;
				frame.origin.x -= BUTTON_GAP;
				view.frame = frame;
			}
		}
	}
	
	[self.view addSubview: self.menuView];
}


- (void) selectBtn: (int) btnTag {
	for (int i = kBtnTag_Intro ; i <= kBtnTag_Contacts ; i++) {
		UIButton *btn = (UIButton*) [self.view viewWithTag: i];
		btn.selected = (btnTag == i);
	}
}


- (void) selectMenu: (int) regLType {
	_selectedMenu = regLType;

	if (_selectedMenu == 2 || _selectedMenu == 5) {
		self.contentView.hidden = YES;
		self.videoView.hidden = NO;
	} else {
		self.contentView.hidden = NO;
		self.videoView.hidden = YES;
		[self.videoPlayer stop];
		[self.videoPlayer.view removeFromSuperview];
	}

	// 0(소개글)
	if (regLType == 0) {
		[self selectBtn: kBtnTag_Intro];
		NSString *url = [NSString stringWithFormat: @"intro.html?%@", [self getCommonParameter]];
		[self loadRedirectUrl: url];
	}
	// 1(사진첩)
	else if (regLType == 1) {
		[self selectBtn: kBtnTag_Album];
		NSString *url = [NSString stringWithFormat: @"gallery.html?%@", [self getCommonParameter]];
		[self loadRedirectUrl: url];
	}
	// 2(동영상) / 5(유투브동영상)
	else if (regLType == 2 || regLType == 5) {
		[self selectBtn: kBtnTag_Video];
		if (_normalTypeData[@"video_file"] && ![_normalTypeData[@"video_file"] isEqualToString: @""]) {
			NSString *videoUrlPath = _normalTypeData[@"video_file"];
			NSURL *videoUrl = [NSURL URLWithString: videoUrlPath];
			self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
			[_videoPlayer prepareToPlay];
			[_videoPlayer.view setFrame: CGRectMake(10, 10, self.videoView.frame.size.width - 20, self.videoView.frame.size.height - 20)];
			[self.videoView addSubview: _videoPlayer.view];
			[_videoPlayer play];
		} else {
			// youtube_code 넘기기
			NSString *url = [NSString stringWithFormat: @"video.html?youtube_code=%@", _normalTypeData[@"reg_youtube"]];
			[self loadRedirectUrl: url];
		}
	}
	// 6(쇼핑몰)
	else if (regLType == 6) {
		NSString *shopUrlPath = [NSString stringWithFormat: @"%@?%@", _normalTypeData[@"reg_shopping_url"], [self getCommonParameter]];
		[CommonUtils loadWeb: shopUrlPath
		  withViewController: self];
	}
	// 7(쿠폰-미사용)
	else if (regLType == 7) {
		
	}
	// LOCATION: 위치
	else if (regLType == 10) {
		[self selectBtn: kBtnTag_Location];
		NSString *url = [NSString stringWithFormat: @"location.html?%@", [self getCommonParameter]];
		[self loadRedirectUrl: url];
	}
	// PHONE : 전화번호
	else if (regLType == 11) {
		[self selectBtn: kBtnTag_Contacts];
		NSString *url = [NSString stringWithFormat: @"phone.html?%@", [self getCommonParameter]];
		[self loadRedirectUrl: url];
	}
	// REPLY : 댓글
	else if (regLType == 12) {
		[self selectBtn: kBtnTag_Reply];
		NSString *url = [NSString stringWithFormat: @"reply.html?%@", [self getCommonParameter]];
		[self loadRedirectUrl: url];
	}
}


- (NSString*) getCommonParameter {
	return [NSString stringWithFormat: @"customer_code=%@&language_code=%@&reg_code=%@&latitude=%@&longitude=%@",
			[[AppDataManager appDataManager] loadData: CUSTOMER_CODE]
			, [CommonUtils getLanguageCode]
			, self.regCode
			, self.latitude
			, self.longitude];
}


- (NSMutableDictionary*)parameterParse:(NSString*)param {
	NSArray *listItems = [param componentsSeparatedByString:@"&"];
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	
	for (NSString * items in listItems) {
		NSArray * itemItems  = [items componentsSeparatedByString:@"="];
		[dic setObject:[itemItems objectAtIndex:1] forKey:[itemItems objectAtIndex:0]];
	}
	
	return dic;
}


- (void) loadRedirectUrl: (NSString*) redirectUrl {
	self.redirectUrl = redirectUrl;
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource: @"web_content/gate" ofType:@"html"];
	NSURL *htmlUrl = [NSURL fileURLWithPath: htmlPath];
	NSMutableURLRequest *htmlRequest = [NSMutableURLRequest requestWithURL: htmlUrl];
	[self.contentWebView loadRequest: htmlRequest];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView: (UIWebView*) webView
shouldStartLoadWithRequest: (NSURLRequest*) request
 navigationType: (UIWebViewNavigationType) navigationType {
	
	NSString *strUrl = [[request URL] absoluteString];
	NSLog(@"shouldStartLoadWithRequest %@", strUrl);
	
	// Gate Page
	if ([strUrl hasPrefix: @"lookey://getPageUrl"]) {
		NSURL *URL = [NSURL URLWithString: strUrl];
		NSString *params = (NSMutableString*)[URL query];
		NSString *callback = [params stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		NSString *script = [NSString stringWithFormat: @"%@('%@');", callback, self.redirectUrl];
		[webView stringByEvaluatingJavaScriptFromString: script];
		return NO;
	} else if ([strUrl hasPrefix: @"lookey://goImageView"]) {
		NSURL *URL = [NSURL URLWithString: strUrl];
		NSString *params = (NSMutableString*)[URL query];
		NSArray *paramsArray = [params componentsSeparatedByString: @"&"];
		NSString *imageUrl = paramsArray[0];
		NSString *imageType = paramsArray[1];
		
		NSString *url = [NSString stringWithFormat: @"image_view.html?image_url=%@&image_type=%@",
						 imageUrl, imageType];
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		LookeyWebViewController *wc = [storyboard instantiateViewControllerWithIdentifier: @"WebViewController"];
		wc.redirectUrl = url;
		wc.topMenuType = kShowMenu_OnlyClose;
		[self presentViewController:wc animated:NO completion: nil];
		return NO;
	}
	
	if ([strUrl hasPrefix: @"http"] || [strUrl hasPrefix: @"file"]) {
		[LoadingHUD show];
	}
	return YES;
}


- (void) webView: (UIWebView*) webView didFailLoadWithError:(NSError *)error {
	NSLog(@"didFailLoadWithError %@", [error localizedDescription]);
	[LoadingHUD dismiss];	
}


- (void) webViewDidFinishLoad: (UIWebView*) webView {
    NSLog(@"webViewDidFinishLoad");
	[LoadingHUD dismiss];
	[webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ", (int)webView.frame.size.width]];
}

#pragma mark - IBAction

- (IBAction)takePictureBtnPressed:(id)sender {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject: self forKey: KEY_GO_TO_MAIN_CONTROLLER];
	[[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATOIN_GO_TO_MAIN object: self userInfo: dictionary];
}


- (void) checkVideoState {
	if (_videoPlayer) {
		[_videoPlayer pause];
	}
}


- (IBAction)shareTwitterBtnPressed:(id)sender {
	[self checkVideoState];
	[CommonUtils loadWeb: _normalTypeData[@"reg_twitter_url"]
	  withViewController: self];
}

- (IBAction)shareFacebookBtnPressed:(id)sender {
	[self checkVideoState];
	[CommonUtils loadWeb: _normalTypeData[@"reg_facebook_url"]
	  withViewController: self];
}

- (IBAction)shareYoutubeBtnPressed:(id)sender {
	[self checkVideoState];
	[CommonUtils loadWeb: _normalTypeData[@"reg_youtube_url"]
	  withViewController: self];
}


- (IBAction)shareWebLinkBtnPressed:(id)sender {
	[self checkVideoState];
	[CommonUtils loadWeb: _normalTypeData[@"reg_web_url"]
	  withViewController: self];
}


- (IBAction)menuBtnPressed:(id)sender {
	NSInteger menuTag = ((UIView*) sender).tag;
	switch (menuTag) {
		case kBtnTag_Intro:
		[self selectMenu: 0];
		break;
		
		case kBtnTag_Album:
		[self selectMenu: 1];
		break;
		
		case kBtnTag_Video:
		[self selectMenu: 2];
		break;
		
		case kBtnTag_Location:
		[self selectMenu: 10];
		break;

		case kBtnTag_Contacts:
		[self selectMenu: 11];
		break;
		
		case kBtnTag_Reply:
			[self selectMenu: 12];
		break;
		
		case kBtnTag_Shopping:
		[self selectMenu: 6];
		break;
		
	}
}

@end

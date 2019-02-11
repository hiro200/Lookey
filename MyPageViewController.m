//
//  MyPageViewController.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "MyPageViewController.h"

#import "RegisterAgreementViewController.h"
#import "RegisterEmailAuthViewController.h"
#import "AddMoreInfoViewController.h"
#import "subMyinfoViewController.h"
#import "subMyMileageViewController.h"
#import "RegisterNewUserViewController.h"
#import "RegisterAgreementViewController.h"
#import "AddMoreInfoViewController.h"
#import "GlobalValues.h"


NSString *const NOTIFICATOIN_COMPLETE_JOIN = @"kNotificationCompleteJoin";
NSString *const KEY_JOIN_CONTROLLER = @"kKeyJoinController";

typedef enum {
	kMyPage_MyMilege,
	kMyPage_MyInfo,
	kMyPage_Register
} eMyPageMode;

@interface MyPageViewController () <RegisterAgreementViewControllerDelegate>
{
	eMyPageMode _myPageMode;
    
    __weak IBOutlet UIView *containerView;    
    
    subMyinfoViewController *svcMyInfo;
    subMyMileageViewController *svcMilage;
    
    CGSize containerSize;
}

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLOBAL_VALUES.myPageViewController = self;
    
    _registerForExistingCustomerBtn.layer.cornerRadius = 10;
    _registerForExistingCustomerBtn.clipsToBounds = YES;
    _registerForNewCustomerBtn.layer.cornerRadius = 10;
    _registerForNewCustomerBtn.clipsToBounds = YES;
    
	// Set Button Rounding
	UIImage *bgImage = _registerForExistingCustomerBtn.currentBackgroundImage;
	UIImage *resizeBgImage = [bgImage resizableImageWithCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)];
	[_registerForExistingCustomerBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];
	[_registerForNewCustomerBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];
	//[_addMoreInfoBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];
	
	// add notification
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiCompleteJoin:) name: NOTIFICATOIN_COMPLETE_JOIN object: nil];
    
    if (containerSize.width == 0) {
        containerSize = containerView.bounds.size;
    }
    
    [self initSubView];
    
    if ([[AppDataManager appDataManager] loadData: CUSTOMER_PHONE]) {
        [self setMyPageMode: kMyPage_MyInfo];
    } else {
        [self setMyPageMode: kMyPage_Register];
    }
}

-(void) initSubView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    svcMyInfo = [storyboard instantiateViewControllerWithIdentifier: @"subMyinfoViewController"];   
    [containerView addSubview:svcMyInfo.view];
        
    svcMilage = [storyboard instantiateViewControllerWithIdentifier: @"subMyMilageViewController"];
    [containerView addSubview:svcMilage.view];
    
    [self setSubviewResizing];
}

-(void) setSubviewResizing{
    CGRect boudSubView = CGRectMake(0, 0, containerSize.width, containerSize.height);
    [svcMilage.view setFrame:boudSubView];
    [svcMyInfo.view setFrame:boudSubView];
}

-(void)ResultAddMoreInfo:(NSString *)result{
    [self setSubviewResizing];
    
    if([result compare:@"0"]!=NSOrderedSame){
        [svcMyInfo reloadData];
        [self setMyPageMode: kMyPage_MyInfo];
    }
}


- (void) setMyPageMode: (eMyPageMode) selectedMyPageMode {
	_myPageMode = selectedMyPageMode;
		
    _registerView.hidden = _myPageMode != kMyPage_Register;
	_myMileageBtn.selected = _myPageMode == kMyPage_MyMilege;
	_myInfoBtn.selected = _myPageMode != kMyPage_MyMilege;
	
	if (_myPageMode == kMyPage_MyMilege) {
		[self getPoints];
	} else if (_myPageMode == kMyPage_MyInfo) {
		//AppDataManager *adm = [AppDataManager appDataManager];
		//_customerNameLabel.text = [adm loadData: @"customer_name"];
		//_customerNationLabel.text = [adm loadData: @"customer_nation"];
		//_customerPhoneLabel.text = [adm loadData: @"customer_phone"];
	}
    
    svcMilage.view.hidden = _myPageMode != kMyPage_MyMilege;
    svcMyInfo.view.hidden = _myPageMode != kMyPage_MyInfo;    
}

-(void)persentREUViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterNewUserViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"RegisterNewUserViewController"];
    [self presentViewController:vc animated:NO completion:nil];
}


#pragma mark - NOTIFICATION

- (void) notiCompleteJoin: (NSNotification*) notification {
	NSDictionary *userInfo = notification.userInfo;
	[self dismissViewTo: userInfo[KEY_JOIN_CONTROLLER]];
	// 회원가입한 이후에는 회원의 정보를 갱신함
    [self ResultAddMoreInfo:@"1"];
}

- (void) dismissViewTo: (UIViewController*) vc {
	UIViewController *presentingVC = vc.presentingViewController;
	if (![vc isKindOfClass: [MyPageViewController class]]) {
		[vc dismissViewControllerAnimated: NO completion:^{
			[self dismissViewTo: presentingVC];
		}];
	}
}

#pragma mark - Network

- (void) getPoints {
	AppDataManager *adm = [AppDataManager appDataManager];
	
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_get_points.php", adm.SERVER_IP];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[LANGUAGE_CODE]	= [CommonUtils getLanguageCode];
	params[CUSTOMER_CODE]	= [adm loadData: CUSTOMER_CODE];
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
	[LoadingHUD show];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[LoadingHUD dismiss];
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
		NSNumber *results = response[RESULTS];
		if ([results intValue] == 1) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			[numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
			NSNumber *formattedPoints = [numberFormatter numberFromString: response[@"points"]];
			NSLog(@"formattedNumberString: %@", formattedPoints);
			//_myMileageLabel.text = [formattedPoints stringValue];
		}else[CommonUtils showLocalizedAlertError:[results intValue]];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"lk_get_newregister Failed : %@", [error localizedDescription]);
		
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
	}];
	[operation start];
}

#pragma mark - IBAction

- (IBAction)backBtnPressed:(id)sender {
	[self dismissViewControllerAnimated: YES completion: nil];
}


- (IBAction)myMielageBtnPressed:(id)sender {
	[self setMyPageMode: kMyPage_MyMilege];
}


- (IBAction)myInfoBtnPressed:(id)sender {
	if ([[AppDataManager appDataManager] loadData: CUSTOMER_PHONE]) {
		[self setMyPageMode: kMyPage_MyInfo];
	} else {
		[self setMyPageMode: kMyPage_Register];
	}
}


- (IBAction)registerExistingUserBtnPressed:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RegisterEmailAuthViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"RegisterExistingUserViewController"];
	[self presentViewController: vc animated: YES completion: nil];
	
}


- (IBAction)registerNewUserBtnPressed:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	RegisterAgreementViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"RegisterAgreementViewController"];
    vc.delegate = self;
	[self presentViewController: vc animated: YES completion: nil];
}


- (IBAction)addMoreInfoBtnPressed:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AddMoreInfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"AddMoreInfoViewController"];
	[self presentViewController: vc animated: YES completion: nil];
	
}

#pragma mark - RegisterAgreementViewControllerDelegate

- (void)RegisterAgreementViewControllerAllAgree:(id)sender{
    
}

#pragma mark - AddMoreInfoViewControllerGalleryDelegate

- (void)DismissAddMoreInfoViewController{
    CGRect boudSubView = CGRectMake(0, 0, containerSize.width, containerSize.height);  
    [svcMyInfo.view setFrame:boudSubView];
}



@end

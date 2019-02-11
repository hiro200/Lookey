//
//  MainPanelController.m
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 26..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "MainPanelController.h"
#import "CameraViewController.h"
#import "MenuViewController.h"
#import "ShareViewController.h"
#import "AppDataManager.h"
#import "Constants.h"
#import "CommonUtils.h"
#import "NoticeViewController.h"
#import "GalleryViewController.h"
#import "LookeyWebViewController.h"
#import "SettingViewController.h"
#import "MyPageViewController.h"
#import "LoadingHUD.h"
#import "HelpViewController.h"
#import "GlobalValues.h"
#import "AppDelegate.h"
#import "IntroViewController.h"



@interface MainPanelController () <ShareViewControllerDelegate, UIViewControllerTransitioningDelegate>
{
	eMenu _selectedMenu;
    CameraViewController *cameraViewController;
}

@property (nonatomic, strong) LookeyWebViewController* lookeyWC;

@end

@implementation MainPanelController

- (void) viewDidLoad {
    [super viewDidLoad];
	
    GLOBAL_VALUES.mainPannelController = self;
    
    // init value
    self.shouldDelegateAutorotateToVisiblePanel = NO;
	self.rightFixedWidth = 250.0f;
    self.leftFixedWidth = 250.0f;
    _selectedMenu = kMenu_None;
    
    // customize view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    cameraViewController = [storyboard instantiateViewControllerWithIdentifier: @"CameraViewController"];
    self.centerPanel = cameraViewController;
	
    ShareViewController *svc = [storyboard instantiateViewControllerWithIdentifier: @"ShareViewController"];
    svc.delegate = self;
    self.leftPanel = svc;
	
	MenuViewController *mvc = [storyboard instantiateViewControllerWithIdentifier: @"MenuViewController"];
	self.rightPanel = mvc;
	
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiSelectShare:) name: NOTIFICATION_SELECT_SHARE object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiSelectMenu:) name: NOTIFICATION_SELECT_MENU object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiGoToMain:) name: NOTIFICATOIN_GO_TO_MAIN object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiGetRegCode:) name: NOTIFICATION_GET_REG_CODE object: nil];
}


- (void) notiSelectMenu: (NSNotification*) notification {
    NSDictionary *userInfo = notification.userInfo;
    [self selectMenu: [userInfo[KEY_SELECT_MENU] intValue]];
}


- (void) notiSelectShare: (NSNotification*) notification {
	[self toggleLeftPanel: nil];
}


- (void) notiGoToMain: (NSNotification*) notification {
	NSDictionary *userInfo = notification.userInfo;
	[self dismissViewTo: userInfo[KEY_GO_TO_MAIN_CONTROLLER]];
}


- (void) dismissViewTo: (UIViewController*) vc {
	UIViewController *presentingVC = vc.presentingViewController;
	if (![vc isKindOfClass: [MainPanelController class]] &&
        ![vc isKindOfClass: [CameraViewController class]] &&
        ![vc isKindOfClass:[IntroViewController class]]) {
		[vc dismissViewControllerAnimated: NO completion:^{
			[self dismissViewTo: presentingVC];
		}];
	}
}


- (NSString*) getCommonParameter {
    AppDataManager *adm = [AppDataManager appDataManager];
    
	return [NSString stringWithFormat: @"customer_code=%@&language_code=%@&server_domain=%@"
			, [[AppDataManager appDataManager] loadData: CUSTOMER_CODE]
			, [CommonUtils getLanguageCode]
			, [NSString stringWithFormat:@"%@", adm.SERVER_IP]];  //source add, change
}


- (void) loadRedirectWeb: (NSString*) url withViewController: (UIViewController*) vc {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.lookeyWC = [storyboard instantiateViewControllerWithIdentifier: @"WebViewController"];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(notiFinishLoadWebPage:) name: NOTIFICATION_FINISH_LOAD_WEB_PAGE object: nil];
	_lookeyWC.redirectUrl = url;
	_lookeyWC.topMenuType = kHideMenu;
	_lookeyWC.view.hidden = YES;
	vc.modalPresentationStyle = UIModalPresentationCurrentContext;
	_lookeyWC.modalPresentationStyle = UIModalPresentationCustom;
	[LoadingHUD show];
}


- (void) notiFinishLoadWebPage: (NSNotification*) notification {
	[LoadingHUD dismiss];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: NOTIFICATION_FINISH_LOAD_WEB_PAGE object: nil];
	_lookeyWC.view.hidden = NO;
	[self presentViewController: _lookeyWC animated:NO completion: ^(void) {
		[self showCenterPanelAnimated:NO];
	}];
}


- (BOOL) checkNetwork {
	if ([CommonUtils isNetworkAvaiable]) {
		return YES;
	}
		
	[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
	return NO;
}

- (void) notiGetRegCode: (NSNotification*) notification {
    NSDictionary *userInfo = notification.userInfo;
//    NSString *regCode = userInfo[REG_CODE];
    NSString *regCode = [[userInfo objectForKey:@"e"] objectForKey:@"img_code"];
    
    if (regCode) {
        [self showCenterPanelAnimated:NO];
        [self dismissViewTo:GLOBAL_VALUES.topViewController];
        [cameraViewController startRegCode:regCode];
    }
}


- (void) selectMenu: (eMenu) selectedMenu {
    _selectedMenu = selectedMenu;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (_selectedMenu) {
			
		// 공지사항
		case kMenu_Notice: {
			if (![self checkNetwork])
				return;
			
			NoticeViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"NoticeViewController"];
            
            //vc.modalPresentationStyle = UIModalPresentationCustom;
            //vc.transitioningDelegate = self;
           
			[self presentViewController: vc animated: YES completion: ^(void) {
				[self showCenterPanelAnimated:NO];
			}];
			break;
		}
		
		// 마이페이지
        case kMenu_MyPage: {
			
			if (![self checkNetwork])
				return;
			
			MyPageViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"MyPageViewController"];
			[self presentViewController: vc animated: YES completion: ^(void) {
				[self showCenterPanelAnimated:NO];
			}];
			break;
        }
		
		// 갤러리
        case kMenu_Gallery: {
            GalleryViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"GalleryViewController"];
			[self presentViewController: vc animated: YES completion: ^(void) {
				[self showCenterPanelAnimated:NO];
			}];
            break;
        }
	
		// LOOKEY
        case kMenu_Lucky: {
			if (![self checkNetwork])
				return;
			[self showCenterPanelAnimated:NO];
			NSString *url = [NSString stringWithFormat: @"lucky/ongoing.html?%@", [self getCommonParameter]];
			[self loadRedirectWeb: url withViewController: self];
            break;
        }
		
		// 상점 네트워크
        case kMenu_StoreNetwork: {
			if (![self checkNetwork])
				return;
			[self showCenterPanelAnimated:NO];
			NSString *url = [NSString stringWithFormat: @"shop/shop_category.html?%@", [self getCommonParameter]];
			[self loadRedirectWeb: url withViewController: self];
            
            break;
        }
		
		// 설정
        case kMenu_Setting: {
			if (![self checkNetwork])
				return;
			
			SettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"SettingViewController"];
            NSDictionary *initData = [[AppDataManager appDataManager] loadData:INIT_DATA];
			vc.nationList = initData[@"servers"];
			[self presentViewController: vc animated: YES completion: ^(void) {
				[self showCenterPanelAnimated:NO];
			}];
            break;
        }
		
		// TODO : 가이드
		case kMenu_Guide: {
            HelpViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"HelpViewController"];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController: vc animated: YES completion: ^(void) {
                [self showCenterPanelAnimated:NO];
            }];

            break;
		}
		case kMenu_Open:
            [self toggleRightPanel: nil];
            break;
        case kMenu_None: {
			// 동영상화면이 뜨고 난위에 rightPanel의 x값이 -248로 변경되어 원점으로 수정
			CGRect rightFrame = self.rightPanelContainer.frame;
			rightFrame.origin.x = 0;
			self.rightPanelContainer.frame = rightFrame;
			[self showCenterPanelAnimated:NO];
			break;
		}
            
    }
}


- (void) stylePanel:(UIView *)panel {}


-(NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - ShareViewControllerDelegate
-(void)ShareViewControllerMenuClose{
    [self toggleLeftPanel:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    TWTSimpleAnimationController *animctrl = [[TWTSimpleAnimationController alloc] init];
//    animctrl.duration = 0.5;
//    animctrl.options = UIViewAnimationOptionTransitionCrossDissolve;
//    return animctrl;
//}

@end

//
//  WebViewController.h
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 29..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "CommonViewController.h"

extern NSString *const NOTIFICATION_FINISH_LOAD_WEB_PAGE;

@interface LookeyWebViewController : CommonViewController
{
    bool _isLookeyUrl;
}


typedef enum {
	kShowMenu_Full,
	kShowMenu_OnlyClose,
	kHideMenu
} eTopMenuType;

@property (nonatomic, strong) NSString *loadUrl;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, assign) eTopMenuType topMenuType;
@property (nonatomic, assign) BOOL isCloseGoMain;
@property (nonatomic, assign) BOOL isCheckLookey;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *prevBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end

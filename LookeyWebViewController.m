//
//  WebViewController.m
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 29..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "LookeyWebViewController.h"

#import "AppDataManager.h"
#import "Constants.h"
#import "LoadingHUD.h"
#import "AppDelegate.h"
#import "GlobalValues.h"
#import "NSDictionary+Object.h"

NSString *const NOTIFICATION_FINISH_LOAD_WEB_PAGE = @"kNotificationFinishLoadWebPage";

@class WebFrame;

@interface UIWebView (JavaScriptAlert) <UIAlertViewDelegate>

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender
runJavaScriptAlertPanelWithMessage:(NSString *)message
initiatedByFrame:(WebFrame *)frame {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

static BOOL diagStat = NO;
static BOOL bSelected = NO;
- (BOOL)webView:(UIWebView *)sender
runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WebFrame *)frame {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                        message: message
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: @"Cancel", nil];
    [alertView show];
    while (!bSelected) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    return diagStat;
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    bSelected = YES;
    diagStat = buttonIndex == 0;
    switch (buttonIndex) {
        case 0:
            NSLog(@"Touch up cancel button");
            break;
        case 1:
            NSLog(@"Touch up ok button");
            break;
        default:
            break;
    }
}

@end

@interface LookeyWebViewController ()

@property (nonatomic, assign) int loadedPageCount;
@property (nonatomic, assign) BOOL bRedirectPageLoaded;
@property (nonatomic, assign) BOOL bGoBackPageLoaded;

@end

@implementation LookeyWebViewController

@synthesize webView, loadedPageCount, bRedirectPageLoaded, bGoBackPageLoaded, topMenuType;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _isCloseGoMain = NO;
        _isLookeyUrl = NO;
        _isCheckLookey = NO;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isCloseGoMain = NO;
        _isLookeyUrl = NO;
        _isCheckLookey = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    if (self.loadUrl) {
        
        [self webviewLoadUrl];
        self.webView.scalesPageToFit = YES;
        
    } else {
        for (id subview in webView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).bounces = NO;
        loadedPageCount = 0;
        bRedirectPageLoaded = NO;
        bGoBackPageLoaded = NO;
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource: @"web_content/gate" ofType:@"html"];
        NSURL *htmlUrl = [NSURL fileURLWithPath: htmlPath];
        NSMutableURLRequest *htmlRequest = [NSMutableURLRequest requestWithURL: htmlUrl];
        [self.webView loadRequest: htmlRequest];
    }
    
    if (topMenuType == kHideMenu) {
        self.menuView.hidden = YES;
        self.webView.frame = self.view.frame;
    } else if (topMenuType == kShowMenu_Full) {
        [self updateButtonsState];
    } else {
        self.homeBtn.hidden = YES;
        self.prevBtn.hidden = YES;
        self.nextBtn.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(becomeActive:) name: NOTIFICATION_BECOME_ACTIVE object: nil];
}

-(void)setLoadUrl:(NSString *)loadUrl{
    
    
    
    _loadUrl = [loadUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_isCheckLookey) {
        if ([[_loadUrl lowercaseString] rangeOfString:@"lookey"].length > 0) {
            _isLookeyUrl = YES;
        }
    }
}

- (NSString *)escape:(NSString *)text
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                        (__bridge CFStringRef)text, NULL,
                                                                        (CFStringRef)@"|!*'();@&=+$,?%#[]",
                                                                        kCFStringEncodingUTF8);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
}

- (void) becomeActive: (NSNotification*) notification {
    [LoadingHUD dismiss];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
}


- (void) updateButtonsState {
    _homeBtn.enabled = webView.canGoBack;
    _prevBtn.enabled = webView.canGoBack;
    _nextBtn.enabled = webView.canGoForward;
}


/**
 Just a small helper function
 that returns the path to our
 Documents directory
 **/
- (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    return documentsDirectoryPath;
}


#pragma mark - WebLoad Code Change part

-(void)webviewLoadUrl{
    
    NSMutableURLRequest *request = nil;
    
    NSLog(@"Load:1");
    
    
//    NSURL *url = [NSURL URLWithString:[ _loadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  

    
    NSString *escapeUrl = [_loadUrl  stringByAddingPercentEscapesUsingEncoding:-2147482590];

    
//    NSString *escapeUrl = [ _loadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    NSString *escapeStr = [escapeUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *decoding = [escapeStr stringByReplacingOccurrencesOfString:@"|" withString:@""];
    
   
    
    NSLog(@"escapeUrl === %@", escapeUrl);
    NSLog(@"escapeStr === %@", escapeStr);
    
//    NSURL *url = [NSURL URLWithString:decoding ];
    
    
    NSURL *url = [NSURL URLWithString:escapeUrl ];
    
    NSLog(@"NSU: %@", url);
    
    
    request = [NSMutableURLRequest requestWithURL: url];
    
    
    if (_isLookeyUrl) {
        AppDataManager *adm = [AppDataManager appDataManager];
        NSLog(@"Load:2");
        [request setHTTPMethod: @"POST"];
        NSMutableString *body = [NSMutableString stringWithFormat: @"customer_code=%@&customer_phone=%@&language_code=%@",
                                 [adm loadData:CUSTOMER_CODE],
                                 [adm loadData:CUSTOMER_PHONE],
                                 [CommonUtils getLanguageCode]];
        
        
        if (GLOBAL_VALUES.ImageSearchResultId != NULL && GLOBAL_VALUES.ImageSearchResultId.length > 0) {
            [body appendFormat:@"&reg_code=%@", GLOBAL_VALUES.ImageSearchResultId];
            NSLog(@"Load:3");
        }
        
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSString *bodyLength = [NSString stringWithFormat:@"%d", body.length];
        
        NSLog(@"BODY Len:%@", bodyLength);
        
        [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
        
    }
    
    //self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.webView loadRequest: request];
}

#pragma mark - IBAction

- (IBAction)homeBtnPressed:(id)sender {
    if (self.loadUrl) {
        [self webviewLoadUrl];
    }
}

- (IBAction)prevBtnPressed:(id)sender {
    [webView goBack];
}

- (IBAction)nextBtnPressed:(id)sender {
    [webView goForward];
}

- (IBAction)closeBtnPressed:(id)sender {
    if (_isCloseGoMain) {
        
        NSLog(@"WebView Close 1");
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject: self forKey: KEY_GO_TO_MAIN_CONTROLLER];
        [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATOIN_GO_TO_MAIN object: self userInfo: dictionary];
    }else{
        NSLog(@"WebView Close 2");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    [LoadingHUD dismiss];
}


- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSString *strUrl = [[request URL] absoluteString];
    NSLog(@"shouldStartLoadWithRequest %@", strUrl);
    
    // Gate Page
    if ([strUrl hasPrefix: @"lookey://getPageUrl"]) {
        NSURL *URL = [NSURL URLWithString: strUrl];
        NSString *params = (NSMutableString*)[URL query];
        NSString *callback = [params stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSString *script = [NSString stringWithFormat: @"%@('%@');", callback, self.redirectUrl];
        [self.webView stringByEvaluatingJavaScriptFromString: script];
        return NO;
    }
    
    // goBack
    else if ([strUrl hasPrefix: @"lookey://goBack"]) {
        
        if (loadedPageCount > 1) {
            bGoBackPageLoaded = YES;
            [self.webView goBack];
        } else {
            [self dismissViewControllerAnimated: YES completion: nil];
        }
        NSLog(@"Loaded Page Count : %d", loadedPageCount);
        return NO;
    }
    
    // Close
    else if ([strUrl hasPrefix: @"lookey://goClose"]) {
        [self dismissViewControllerAnimated: YES completion: nil];
        return NO;
    }
    // setUserInfo
    else if ([strUrl hasPrefix: @"lookey://setUserInfo"]) {
        NSURL *URL = [NSURL URLWithString: strUrl];
        NSString *content = (NSMutableString*) [URL query];
        NSArray *userInfos = [content componentsSeparatedByString: @"&"];
        NSString *customerCode = userInfos[0];
        NSString *userCountry = userInfos[1];
        NSString *userPhone = userInfos[2];
        NSString *callback = userInfos[3];
        if (![customerCode isEqualToString: @"undefined"])
            [[AppDataManager appDataManager] saveData: CUSTOMER_CODE value: customerCode];
        [[AppDataManager appDataManager] saveData: @"customer_country" value: userCountry];
        [[AppDataManager appDataManager] saveData: CUSTOMER_PHONE value: userPhone];
        NSString *script = [NSString stringWithFormat: @"%@();", callback];
        [self.webView stringByEvaluatingJavaScriptFromString: script];
        return NO;
    }
    
    // go Back으로 페이지가 로드된 경우
    if (bGoBackPageLoaded) {
        bGoBackPageLoaded = NO;
        --loadedPageCount;
    } else {
        ++loadedPageCount;
        if (! bRedirectPageLoaded) {
            bRedirectPageLoaded = YES;
            --loadedPageCount;
        }
    }
    if ([strUrl hasPrefix: @"http"] || [strUrl hasPrefix: @"file"]) {
        //[LoadingHUD show];
    }
    
    [self updateButtonsState];
    NSLog(@"Loaded Page Count : %d", loadedPageCount);
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [LoadingHUD dismiss];
    [self updateButtonsState];
    if (self.loadUrl || loadedPageCount > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_FINISH_LOAD_WEB_PAGE object: nil];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self updateButtonsState];
}

@end

//
//  RegisterAgreementViewController.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "RegisterAgreementViewController.h"
#import "RegisterNewUserViewController.h"
#import "AgreementViewController.h"
#import "GlobalValues.h"
#import "MyPageViewController.h"

@interface RegisterAgreementViewController ()

@end

@implementation RegisterAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *bgImage = _checkAgreeBtn.currentBackgroundImage;
	UIImage *resizeBgImage = [bgImage resizableImageWithCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)];
	[_checkAgreeBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];
	_contentScrollView.contentSize = CGSizeMake(320, 670);
	
    NSDictionary *listconditions = [[AppDataManager appDataManager] loadData:AGREE_CONDITION];
    if (listconditions != nil) {
        [self setCondition:listconditions];
    }else
        [self performSelector: @selector(getCondition) withObject: nil afterDelay: 0.0f];
}


- (void) getCondition {
	AppDataManager *adm = [AppDataManager appDataManager];
	
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_get_condition.php", adm.SERVER_IP];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[LANGUAGE_CODE]	= [CommonUtils getLanguageCode];
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
	[LoadingHUD show];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[LoadingHUD dismiss];
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
        NSNumber *results = response[RESULTS];
        if ([results intValue] == 1)
            [self setCondition:response];
        else
            [CommonUtils showLocalizedAlertError:[results intValue]];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"lk_get_condition Failed : %@", [error localizedDescription]);
		
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL"withViewController:self];
	}];
	[operation start];
}

-(void)setCondition:(NSDictionary *)dic{
    _serviceTextView.text = [self convertStringFromWeb: dic[@"condition1"]];
    _serviceTextView.textColor = [UIColor colorWithRed: 103/255.0 green: 116/255.0 blue: 130/255.0 alpha: 1.0f];
    _privacyTextView.text = [self convertStringFromWeb: dic[@"condition2"]];
    _privacyTextView.textColor = [UIColor colorWithRed: 103/255.0 green: 116/255.0 blue: 130/255.0 alpha: 1.0f];
    _tradeTextView.text = [self convertStringFromWeb: dic[@"condition3"]];
    _tradeTextView.textColor = [UIColor colorWithRed: 103/255.0 green: 116/255.0 blue: 130/255.0 alpha: 1.0f];
}

- (NSString*) convertStringFromWeb: (NSString*) webStr {
	return [webStr stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
}


#pragma mark - IBAction

- (IBAction)backBtnPressed:(id)sender {
	[self dismissViewControllerAnimated: YES completion: nil];
}


- (IBAction)agreeAllBtnPressed:(id)sender {
	if (!_agreeServiceBtn.selected) {
		[CommonUtils showLocalizedAlert: @"MSG_AGREE_SERVICE" withViewController:self];
		return;
	}
	
	if (!_agreePrivacyBtn.selected) {
		[CommonUtils showLocalizedAlert: @"MSG_AGREE_PRIVACY" withViewController:self];
		return;
	}
	
	if (!_agreeTradeBtn.selected) {
		[CommonUtils showLocalizedAlert: @"MSG_AGREE_TRADE" withViewController:self];
		return;
	}
    
    
//    if (self.delegate != nil) {
//        [self.delegate RegisterAgreementViewControllerAllAgree:self];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (GLOBAL_VALUES.myPageViewController==nil) {
            return;
        }
        
        [GLOBAL_VALUES.myPageViewController performSelector:@selector(persentREUViewController) withObject:nil afterDelay:0];
    }];
}


- (IBAction)agreeServiceBtnPressed:(id)sender {
	_agreeServiceBtn.selected = !_agreeServiceBtn.selected;
}


- (IBAction)agreePrivacyBtnPressed:(id)sender {
	_agreePrivacyBtn.selected = !_agreePrivacyBtn.selected;
}


- (IBAction)agreeTradeBtnPressed:(id)sender {
	_agreeTradeBtn.selected = !_agreeTradeBtn.selected;
}

- (IBAction)onShowDetail01:(id)sender {
    [self showDetail:1];
}

- (IBAction)onShowDetail02:(id)sender {
    [self showDetail:2];
}

- (IBAction)onShowDetail03:(id)sender {
    [self showDetail:3];
}

-(void)showDetail:(int)num{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AgreementViewController *avc = [storyboard instantiateViewControllerWithIdentifier: @"AgreementViewController"];
    avc.agreementTitle = [CommonUtils getLocalizedString: @"TITLE_SERVICE_AGREEMENT"];
    avc.agreeType = num;
    [self presentViewController: avc animated: NO completion: ^(void) {
    }];
}


@end

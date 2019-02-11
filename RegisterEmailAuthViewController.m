//
//  RegisterExistingUserViewController.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "RegisterEmailAuthViewController.h"
#import "ChangePhoneViewController.h"

const int PASSWORD_MIN_COUNT_MOD = 8;

@interface RegisterEmailAuthViewController () <UITextFieldDelegate>

@end

@implementation RegisterEmailAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];	
	_passwordTextField.secureTextEntry = YES;
	
	UIImage *bgImage = _registerBtn.currentBackgroundImage;
	UIImage *resizeBgImage = [bgImage resizableImageWithCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)];
	[_registerBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];
    
    _registerBtn.layer.cornerRadius = 10;
    _registerBtn.clipsToBounds = YES;
}


#pragma mark - Network

- (void) login {
	AppDataManager *adm = [AppDataManager appDataManager];
	
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_login.php", adm.SERVER_IP];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[LANGUAGE_CODE]			= [CommonUtils getLanguageCode];
	params[@"customer_email"]		= _emailTextField.text;
	params[@"customer_password"]	= _passwordTextField.text;
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
	[LoadingHUD show];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[LoadingHUD dismiss];
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
		NSNumber *results = response[RESULTS];
		if ([results intValue] == 1) {
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			ChangePhoneViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"ChangePhoneViewController"];
            [vc setCustomerOldCode:response[CUSTOMER_CODE]];
			[self presentViewController: vc animated: NO completion: nil];
		} else {
			//[CommonUtils showLocalizedAlert: @"MSG_NOT_EXIST_USER"];
            [CommonUtils showLocalizedAlertError:[results intValue]];
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"lk_login.php Failed : %@", [error localizedDescription]);
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
	}];
	[operation start];
}


#pragma mark - IBActions

- (IBAction)backBtnPressed:(id)sender {
	[self dismissViewControllerAnimated: YES completion: nil];
}


- (IBAction)registerBtnPressed:(id)sender {
	[self dismissKeyboard];
	
	NSString *email = _emailTextField.text;
	if (email.length == 0) {
		[CommonUtils showLocalizedAlert: @"MSG_INPUT_EMAIL" withViewController:self];
		return;
	}
	
	if (![CommonUtils isValidEmail: email]) {
		[CommonUtils showLocalizedAlert: @"MSG_CHECK_EMAIL" withViewController:self];
		return;
	}
	
	NSString *password = _passwordTextField.text;
	if ([password isEqualToString: @""])  {
		[CommonUtils showLocalizedAlert: @"MSG_INPUT_PASSWORD" withViewController:self];
		return;
	}

	if (password.length < PASSWORD_MIN_COUNT_MOD) {
		[CommonUtils showLocalizedAlert: @"MSG_TOO_SHORT_PASSWORD" withViewController:self];
		return;
	}
	
	[self login];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // 회원정보
    if(textField == _emailTextField) [_passwordTextField becomeFirstResponder];
    else [self dismissKeyboard];
    
    return YES;
}

@end

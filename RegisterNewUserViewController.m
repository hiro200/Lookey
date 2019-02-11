//
//  RegisterNewUserViewController.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "RegisterNewUserViewController.h"

#import "MyPageViewController.h"
#import "AuthPhoneViewController.h"
#import "GlobalValues.h"

const int TAG_JOIN_ALERT_VIEW		= 10000;
const int TAG_COMPLETE_ALERT_VIEW	= 10001;
const int TAG_NEED_TO_AUTH_ALERT_VIEW = 10002;


@implementation RegisterNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	UIImage *bgImage = _registerBtn.currentBackgroundImage;
	UIImage *resizeBgImage = [bgImage resizableImageWithCapInsets: UIEdgeInsetsMake(12, 12, 12, 12)];
	[_registerBtn setBackgroundImage: resizeBgImage forState: UIControlStateNormal];

	[self showNationList: NO];
	_selectedNationIndex = -1;
	
    NSDictionary *dicNC = [[AppDataManager appDataManager] loadData:NATION_CODE_LIST];
    
    if (dicNC != nil) {
        [self loadPickerView:dicNC[@"banks"]];
    }else{
        [self performSelector: @selector(getNationList) withObject: nil afterDelay: 0.0f];
    }
    
    _registerBtn.layer.cornerRadius = 10;
    _registerBtn.clipsToBounds = YES;
}


- (void) getNationList {
	AppDataManager *adm = [AppDataManager appDataManager];
	
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_get_nation.php", adm.SERVER_IP];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[LANGUAGE_CODE]	= [CommonUtils getLanguageCode];
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
	[LoadingHUD show];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		[LoadingHUD dismiss];
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
        NSNumber *results = response[RESULTS];
        
        if ([results intValue] == 1) {
            [self loadPickerView:response[@"banks"]];
            [_nationPickerView reloadAllComponents];
        }else
            [CommonUtils showLocalizedAlertError:[results intValue]];
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"lk_get_nation Failed : %@", [error localizedDescription]);
		
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
	}];
    
	[operation start];
}

- (void)loadPickerView:(NSArray *)dic
{
    _nationList = dic;
    [_nationPickerView reloadAllComponents];
    
    NSString *szNationCode = [[AppDataManager appDataManager] loadData:INTERNATIONAL_CODE];
    
    if(szNationCode==NULL || szNationCode.length == 0){
        if (_nationList.count>0) {
            _selectedNationIndex = 0;
            _nationTextField.text = [self getNationText: _nationList[0]];
            [_nationPickerView selectRow:_selectedNationIndex inComponent:0 animated:NO];
        }
        return;
    }
    
    NSDictionary *item;
    for (int i=0; i<_nationList.count; i++) {
        item = _nationList[i];
        if ([szNationCode compare:item[@"nation_phcode"]]==NSOrderedSame) {
            _selectedNationIndex = i;
            _nationTextField.text = [self getNationText: item];
           [_nationPickerView selectRow:_selectedNationIndex inComponent:0 animated:NO];
            break;
        }
    }
}

- (void) join {
    [self dismissKeyboard];
    
    NSLog(@"USER Join: 1");
    
	AppDataManager *adm = [AppDataManager appDataManager];
	
	NSString *serverIP = [NSString stringWithFormat: @"%@/xml/lk_joinus.php", adm.SERVER_IP];
	
	NSMutableDictionary *params = [NSMutableDictionary new];
	params[@"user_step"] = @"0";
	params[@"user_code"] = [adm loadData: CUSTOMER_CODE];
	params[@"user_name"]	= _nameTextField.text;
	params[@"user_phone"]	= _phoneTextField.text;
	params[@"user_country"]	= _nationList[_selectedNationIndex][@"nation_phcode"];
	
	AFHTTPRequestOperation *operation = [CommonUtils wrapAFHTTPRequestOperation: serverIP
																		 params: params];
	
    
	[LoadingHUD show];
    
    NSLog(@"USER Join: %@", operation);
    
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dismissKeyboard];
		[LoadingHUD dismiss];
        
        
        
		NSDictionary *response = [CommonUtils getJSONObj: responseObject];
		NSNumber *results = response[RESULTS];
		if ([results intValue] == 1) {
            [self saveMyInfoWithJoinus:response];
            [CommonUtils showLocalizedAlert: @"MSG_SUCCESS_REGISTER"
							   withDelegate: self
									withTag: TAG_COMPLETE_ALERT_VIEW];
            
		}
		// 이미 가입한 회원인 경우
		else if ([results intValue] == 2){
			[CommonUtils showLocalizedAlert: @"MSG_ALREADY_JOINED"
							   withDelegate: self
									withTag: TAG_NEED_TO_AUTH_ALERT_VIEW];
		} else {
			//[CommonUtils showLocalizedAlert: @"MSG_ERROR_TRY_AGAIN"];
            [CommonUtils showLocalizedAlertError:[results intValue]];
            
            
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[LoadingHUD dismiss];
		NSLog(@"lk_joinus Failed : %@", [error localizedDescription]);
		[CommonUtils showLocalizedAlert: @"NETWORK_CONNECTOIN_FAIL" withViewController:self];
        [self dismissKeyboard];
	}];
	[operation start];
}

- (void) saveMyInfoWithJoinus:(NSDictionary *)response
{
    AppDataManager *adm = [AppDataManager appDataManager];
    [adm saveData: CUSTOMER_CODE value: response[CUSTOMER_CODE]];
    [adm saveData: CUSTOMER_PHONE value: response[CUSTOMER_PHONE]];
    
    NSString *sznationcode = response[@"customer_nation"];
    if (sznationcode == nil || [sznationcode isEqual:[NSNull null]] || sznationcode.length == 0) {
        sznationcode = _nationList[_selectedNationIndex][@"nation_phcode"];
    }
    
    [adm saveData: INTERNATIONAL_CODE value: sznationcode];
    
    NSMutableDictionary *dicMyInfo = [NSMutableDictionary dictionaryWithDictionary:[adm loadData:MY_INFO]];
    
    
    dicMyInfo[@"customer_name"] = response[@"customer_name"];
    dicMyInfo[@"customer_email"] = response[@"customer_email"];
    dicMyInfo[@"customer_zipcode"] = response[@"customer_zipcode"];
    dicMyInfo[@"customer_address"] = response[@"customer_address"];
    dicMyInfo[@"customer_gender"] = response[@"customer_gender"];
    dicMyInfo[@"customer_birthday"] = response[@"customer_birthday"];
    dicMyInfo[@"customer_phone"] = response[@"customer_phone"];
    dicMyInfo[@"customer_nation"] = response[@"customer_nation"];
    dicMyInfo[@"customer_exist_photo"] = response[@"customer_exist_photo"];
    dicMyInfo[@"customer_photo"] = response[@"customer_photo"];
    dicMyInfo[@"bank_code"] = response[@"bank_code"];
    dicMyInfo[@"bank_account"] = response[@"bank_account"];
    [adm saveData:MY_INFO value:dicMyInfo];
    
    NSMutableDictionary *dicInit = [NSMutableDictionary dictionaryWithDictionary:[adm loadData:INIT_DATA]];
    dicInit[@"comp_links_count"] = response[@"comp_links_count"];
    dicInit[@"comp_links"] = response[@"comp_links"];
    [adm saveData:INIT_DATA value:dicInit];
}

-(void)AuthPhoneComplated{
    [self dismissViewControllerAnimated:NO completion:^{
        [GLOBAL_VALUES.myPageViewController performSelector:@selector(ResultAddMoreInfo:) withObject:@"1" afterDelay:0];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == TAG_JOIN_ALERT_VIEW) {
		if (buttonIndex == 1) {
			[self join];
		}
	}
	else if (alertView.tag == TAG_COMPLETE_ALERT_VIEW) {
        [self dismissViewControllerAnimated:NO completion:^{
            [GLOBAL_VALUES.myPageViewController performSelector:@selector(ResultAddMoreInfo:) withObject:@"1" afterDelay:0];
        }];
	}
	else if (alertView.tag == TAG_NEED_TO_AUTH_ALERT_VIEW) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
		AuthPhoneViewController *vc = [storyboard instantiateViewControllerWithIdentifier: @"AuthPhoneViewController"];
		vc.customerName = _nameTextField.text;
		vc.customerPhone = _phoneTextField.text;
		vc.customerCountry = _nationList[_selectedNationIndex][@"nation_phcode"];
        vc.target = self;
        vc.oncomplated = @selector(AuthPhoneComplated);
		[self presentViewController: vc animated: NO completion: nil];
	}
}



#pragma mark - IBAction

- (IBAction)backBtnPressed:(id)sender {
	[self dismissViewControllerAnimated: YES completion: nil];
}


- (IBAction)registerBtnPressed:(id)sender {
    [self dismissKeyboard];
	if ([_nameTextField.text isEqualToString: @""]) {
		[CommonUtils showLocalizedAlert: @"MSG_INPUT_NAME" withViewController:self];
		return;
	}
	
	if ([_phoneTextField.text isEqualToString: @""]) {
		[CommonUtils showLocalizedAlert: @"MSG_INPUT_PHONE_NUMBER" withViewController:self];
		return;
	}
	
	if (_selectedNationIndex < 0) {
		[CommonUtils showLocalizedAlert: @"MSG_SELECT_NATION" withViewController:self];
		return;
	}
	
	[self dismissKeyboard];
	NSString *message = [NSString stringWithFormat: @"%@ : %@\n%@ : %@\n%@ : %@\n\n%@"
						 , [CommonUtils getLocalizedString: @"WORD_NAME"]
						 , _nameTextField.text
						 , [CommonUtils getLocalizedString: @"WORD_NATION_NUMBER"]
						 , _nationList[_selectedNationIndex][@"nation_phcode"]
						 , [CommonUtils getLocalizedString: @"WORD_PHONE_NUMBER"]
						 , _phoneTextField.text
						 , [CommonUtils getLocalizedString: @"MSG_QUERY_JOIN"]						 ];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: [CommonUtils getLocalizedString: @"TITLE_CONFIRM_JOIN"]
														message: message
													   delegate: self
											  cancelButtonTitle: [CommonUtils getLocalizedString: @"BTN_CANCEL"]
											  otherButtonTitles: [CommonUtils getLocalizedString: @"BTN_CONFIRM"], nil];
    alertView.tag = TAG_JOIN_ALERT_VIEW;
	[alertView show];
}


- (IBAction)chooseNation:(id)sender {
	[self showNationList: NO];
}


- (IBAction)inputNationBtnPressed:(id)sender {
	[self dismissKeyboard];
	[self showNationList: YES];	
}


- (void) showNationList: (BOOL) bShow {
	_nationPickerView.hidden = !bShow;
	_nationToolbar.hidden = !bShow;
}


- (NSString*) getNationText: (NSDictionary*) nationInfo {
	return [NSString stringWithFormat: @"%@ (%@)", nationInfo[@"nation_name"], nationInfo[@"nation_phcode"]];
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSDictionary *nationInfo = _nationList[row];
	_selectedNationIndex = (int)row;
	_nationTextField.text = [self getNationText:nationInfo];
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSDictionary *nationInfo = _nationList[row];
	return [self getNationText: nationInfo];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return _nationList.count;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self showNationList: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self dismissKeyboard];
	return YES;
}

@end

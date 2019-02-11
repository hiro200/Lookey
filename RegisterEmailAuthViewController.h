//
//  RegisterExistingUserViewController.h
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "CommonViewController.h"

@interface RegisterEmailAuthViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

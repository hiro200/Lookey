//
//  MyPageViewController.h
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "CommonViewController.h"

extern NSString *const NOTIFICATOIN_COMPLETE_JOIN;
extern NSString *const KEY_JOIN_CONTROLLER;

@interface MyPageViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIButton *myMileageBtn;
@property (weak, nonatomic) IBOutlet UIButton *myInfoBtn;


// 등록 및 신규가입
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *registerForExistingCustomerBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerForNewCustomerBtn;

-(void)ResultAddMoreInfo:(NSString *)result;
-(void)persentREUViewController;
@end

//
//  RegisterAgreementViewController.h
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "CommonViewController.h"

@protocol RegisterAgreementViewControllerDelegate

@required
- (void)RegisterAgreementViewControllerAllAgree:(id)sender;
@end

@interface RegisterAgreementViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkAgreeBtn;

// 서비스 이용 약관
@property (weak, nonatomic) IBOutlet UIButton *agreeServiceBtn;
@property (weak, nonatomic) IBOutlet UITextView *serviceTextView;

// 개인정보 취급방침
@property (weak, nonatomic) IBOutlet UIButton *agreePrivacyBtn;
@property (weak, nonatomic) IBOutlet UITextView *privacyTextView;

// 전자금융거래 이용약관
@property (weak, nonatomic) IBOutlet UIButton *agreeTradeBtn;
@property (weak, nonatomic) IBOutlet UITextView *tradeTextView;

@property(nonatomic,assign) id<RegisterAgreementViewControllerDelegate> delegate;


@end

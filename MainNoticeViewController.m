//
//  MainNoticeViewController.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 13..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "MainNoticeViewController.h"
#import "GlobalValues.h"
#import "UIImageView+Async.h"

@interface MainNoticeViewController ()
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIButton *btnClose;
    __weak IBOutlet UIButton *btnExit;
}
@end

@implementation MainNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch(GLOBAL_VALUES.typeMainNotice){
        case -1: btnClose.hidden = YES; break;
        case 1: btnExit.hidden = YES; break;
        default: [self dismissViewControllerAnimated:NO completion:nil]; return;
    }
    
    [imageView loadImageFromURL:[NSURL URLWithString:GLOBAL_VALUES.imageMainNotice] style:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickedClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickedExit:(id)sender {
    exit(0);
}

@end

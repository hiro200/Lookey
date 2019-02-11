//
//  MenuViewViewController.m
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 26..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "MenuViewController.h"

#import "MainPanelController.h"
#import "GalleryViewController.h"
#import "GlobalValues.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)closedBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_None];
}

- (IBAction)noticeBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_Notice];
}

- (IBAction)myPageBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_MyPage];
}

- (IBAction)galleryBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_Gallery];
}

- (IBAction)luckyBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_Lucky];
}

- (IBAction)storeNetworkBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_StoreNetwork];
}

- (IBAction)settingBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_Setting];
}

- (IBAction)guideBtnPressed:(id)sender {
	[self sendNotificationForSelectingMenu: kMenu_Guide];
}


#pragma mark - LOGIC

- (void) sendNotificationForSelectingMenu: (eMenu) selectedMenu {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject: [NSString stringWithFormat: @"%d", selectedMenu] forKey: KEY_SELECT_MENU];
	[[NSNotificationCenter defaultCenter] postNotificationName: NOTIFICATION_SELECT_MENU object: self userInfo: dictionary];
}

@end

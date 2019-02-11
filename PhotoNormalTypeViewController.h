//
//  PhotoNormalTypeViewController.h
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 6..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "CommonViewController.h"

@interface PhotoNormalTypeViewController : CommonViewController

@property (nonatomic, strong) NSDictionary *normalTypeData;
@property (nonatomic, strong) NSString *regCode;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (weak, nonatomic) IBOutlet UIButton *takePictureBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareTwitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareYoutubeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareWebLinkBtn;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *menuIntroBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuAlbumBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuShoppingBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuReplyBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuContactsBtn;

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *videoView;


@end

//
//  VideoViewController.h
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 10..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface PlayVideoViewController : CommonViewController

@property (nonatomic, strong) NSString *videoUrlPath;
@property (nonatomic, strong) NSString *forwardUrlPath;

@end

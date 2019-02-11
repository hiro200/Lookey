//
//  LoadingHUB.m
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 26..
//  Copyright (c) 2015년 comants. All rights reserved.
//


#import "LoadingHUD.h"

@interface LoadingHUD ()

@property (nonatomic, strong, readonly) UIControl *overlayView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

- (void) show;
- (void) dismiss;

@end


@implementation LoadingHUD

@synthesize overlayView, imageView, indicator;

+ (LoadingHUD*)sharedView {
    static dispatch_once_t once;
    static LoadingHUD *sharedView;
    dispatch_once(&once, ^ {
		sharedView = [[self alloc] init];
	});
    return sharedView;
}

+ (void)show {
    [[self sharedView] show];
}


+ (void) dismiss {
    [[self sharedView] dismiss];
}


- (id) init {
    if (self = [super init]) {
        self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"loading01"]];
        self.imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
		
		NSMutableArray *loadingImageArray = [NSMutableArray array];
		for (int i = 1 ; i <= 12 ; i++) {
			UIImage *image = [UIImage imageNamed: [NSString stringWithFormat: @"loading%02d", i]];
			[loadingImageArray addObject: image];
		}
		self.imageView.animationImages = loadingImageArray;
		self.imageView.animationDuration = 2.0f;
		
    }
    return self;
}


- (UIControl *)overlayView {
    if(!overlayView) {
        overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
    }
    return overlayView;
}


- (void)show {
	
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    }

	
    [self.overlayView addSubview: self.imageView];
	[self.imageView startAnimating];

}


- (void) dismiss {
    [imageView removeFromSuperview];
//	[indicator removeFromSuperview];
    [overlayView removeFromSuperview];
    overlayView = nil;
}

@end

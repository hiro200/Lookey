//
//  UIImageViewAsync.h
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 1..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIImageViewAsync;

@protocol UIImageViewAsyncDelegate

@optional
- (void)LoadImageCompatedUIImageView:(UIImageViewAsync*)sender;
@end

@interface UIImageViewAsync : UIImageView

@property(nonatomic,assign) id<UIImageViewAsyncDelegate> delegateAsync;

- (BOOL)loadImageFromURL:(NSURL *)url;
- (BOOL)loadImageFromURL:(NSURL *)url style:(UIActivityIndicatorViewStyle)style;
- (BOOL)loadImageFromURLSynchronously:(NSURL *)url;

@end

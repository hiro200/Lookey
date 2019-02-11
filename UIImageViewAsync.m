//
//  UIImageViewAsync.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 1..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "UIImageViewAsync.h"
#import "UIImageView+Async.h"

@implementation UIImageViewAsync

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)loadImageFromURLSynchronously:(NSURL *)url{
    bool bresult = [super loadImageFromURLSynchronously:url];
    
    if (_delegateAsync != nil) {
        [_delegateAsync LoadImageCompatedUIImageView:self];
    }
    
    return bresult;
}

- (BOOL)loadImageFromURL:(NSURL *)url{
    return [super loadImageFromURL:url];
}

- (BOOL)loadImageFromURL:(NSURL *)url style:(UIActivityIndicatorViewStyle)style{
    return [super loadImageFromURL:url style:style];
}

@end

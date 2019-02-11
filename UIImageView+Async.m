//
//  UIImageView+Async.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 6. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "UIImageView+Async.h"


/***************************************************************************
 
 Interface UIImageView (AsyncPrivate)
 
 ***************************************************************************/
@interface UIImageView (AsyncPrivate)
- (void)startLoadingViewWithStyle:(UIActivityIndicatorViewStyle)style;
- (void)endLoadingView;
@end
/***************************************************************************
 
 Tags
 
 ***************************************************************************/
#define kActivityViewTag                (3267)
/***************************************************************************
 
 Implementation UIImageView (Async)
 
 ***************************************************************************/
@implementation UIImageView (Async)
/***************************************************************************
 
 Implementation Methods (Load)
 
 ***************************************************************************/
#pragma mark -
#pragma mark Methods (Load)
/**
 @param[in] url          네트워크상의 이미지 경로
 
 @return                 로딩 시작 성공 여부
 
 네트워크상에 있는 이미지를 불러와서 화면에 나타냅니다.
 비동기 방식으로 처리되며, 이미지를 불러오는동안(다운로드받는 동안) indicator 가 나타납니다.
 */
- (BOOL)loadImageFromURL:(NSURL *)url {
    return [self loadImageFromURL:url style:UIActivityIndicatorViewStyleWhite];
}
/**
 @param[in] url          네트워크상의 이미지 경로
 @param[in] style        Activity Indicator Style
 
 @return                 로딩 시작 성공 여부
 
 네트워크상에 있는 이미지를 불러와서 화면에 나타냅니다.
 비동기 방식으로 처리되며, 이미지를 불러오는동안(다운로드받는 동안) indicator 가 나타납니다.
 */
- (BOOL)loadImageFromURL:(NSURL *)url style:(UIActivityIndicatorViewStyle)style {
    [self startLoadingViewWithStyle:style];
    [self performSelectorInBackground:@selector(loadImageFromURLSynchronously:) withObject:url];
    return YES;
}
/**
 @param[in] url          네트워크상의 이미지 경로
 
 @return                 로딩 시작 성공 여부
 
 네트워크상에 있는 이미지를 불러와서 화면에 나타냅니다.
 동기 방식으로 처리됩니다.
 */
- (BOOL)loadImageFromURLSynchronously:(NSURL *)url {
    NSURLRequest                * urlRequest;
    NSURLResponse               * urlResponse;
    NSError                     * error = nil;
    NSData                      * retData = nil;
    //NSAutoreleasePool           * autoreleasePool = nil;
    BOOL                        ret = YES;
    
    
    /**
     1. Start Autorelease Pool
     */
    //autoreleasePool = [[NSAutoreleasePool alloc] init];
    /**
     2. Process
     */
    urlRequest = [NSURLRequest requestWithURL:url];
    retData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    [self endLoadingView];
    if( error || retData==nil ){
        ret = NO;
    }else{
        self.image = [UIImage imageWithData:retData];
        ret = YES;
    }
    /**
     3. End Autorelease Pool
     */
    //[autoreleasePool release];
    
    return ret;
}
@end
/***************************************************************************
 
 Implementation UIImageView (AsyncPrivate)
 
 ***************************************************************************/
@implementation UIImageView (AsyncPrivate)
- (void)startLoadingViewWithStyle:(UIActivityIndicatorViewStyle)style {
    UIActivityIndicatorView     * activityView;
    
    @synchronized(self){
        activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
        if( activityView==nil ){
            //style = UIActivityIndicatorViewStyleGray;
            activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
            [activityView setTag:kActivityViewTag];
            [activityView setCenter:self.center];
            [activityView startAnimating];
            [activityView setCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)];
            [self addSubview:activityView];
        }
    }
}
- (void)endLoadingView {
    UIActivityIndicatorView     * activityView;
    
    @synchronized(self){
        activityView = (UIActivityIndicatorView *)[self viewWithTag:kActivityViewTag];
        if( activityView ){
            [activityView removeFromSuperview];
        }
    }
}
@end


//
//  UIImageView+Async.h
//  Lookey
//
//  Created by nexbiz-korea on 2015. 6. 30..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#ifndef Lookey_UIImageView_Async_h
#define Lookey_UIImageView_Async_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 
 Interface UIImageView (Async)
 
 네트워크상에 있는 이미지를 동기 및 비동기로 로딩하기 위한 UIImageView 의 카테고리 입니다.
 UIImageView 의 initWithFrame 을 통해서 초기화를 하고 loadImageFromURL 메소드를
 통해서 특정 URL 의 이미지를 로딩하도록 합니다.
 이미지 로딩중일동안 UIActivityIndicatorView 가 나타납니다.
 
 */
@interface UIImageView (Async)
- (BOOL)loadImageFromURL:(NSURL *)url;
- (BOOL)loadImageFromURL:(NSURL *)url style:(UIActivityIndicatorViewStyle)style;
- (BOOL)loadImageFromURLSynchronously:(NSURL *)url;
@end

#endif

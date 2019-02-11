//
//  SearchImageUtil.h
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 3..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SearchImageDelegate <NSObject>

- (void) searchImageResult: (NSString*) resultCode;

@end

@interface SearchImageUtil : NSObject

- (id) initWithDelegate: (id<SearchImageDelegate>) delegate
				  image: (UIImage*) image;

@end

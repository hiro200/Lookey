//
//  UICricleButton.h
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 24..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICricleButton;

@protocol UICricleButtonDelegate

@optional
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event View:(id)sender;
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event View:(id)sender;
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event View:(id)sender;
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event View:(id)sender;
@end

@interface UICricleButton : UIButton

@property(nonatomic,assign) id<UICricleButtonDelegate> delegate;

-(void)setMaxCircleSize:(CGSize)size;
-(CGSize)getCircleSize;

@end

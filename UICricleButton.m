//
//  UICricleButton.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 24..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "UICricleButton.h"

@interface UICricleButton()
{
    CGSize maxCircleSize;
    CGSize curSize;
}

@end

@implementation UICricleButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    curSize = rect.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    //CGContextSetLineWidth(context, 2.0);
    if (maxCircleSize.width > 0 && maxCircleSize.height > 0) {
        CGRect rc = CGRectMake((rect.size.width-maxCircleSize.width)/2,
                               (rect.size.height-maxCircleSize.height)/2,
                               maxCircleSize.width,
                               maxCircleSize.height);
        CGContextFillEllipseInRect (context, rc);
    }else
        CGContextFillEllipseInRect (context, rect);
    //CGContextStrokeEllipseInRect(context, rect);
    CGContextFillPath(context);
}

-(void)setMaxCircleSize:(CGSize)size{
    maxCircleSize = size;
}

-(CGSize)getCircleSize{
    if (maxCircleSize.width > 0 && maxCircleSize.height > 0)
        return maxCircleSize;
    return curSize;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_delegate != nil) {
        [_delegate touchesBegan:touches withEvent:event View:self];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_delegate != nil) {
        [_delegate touchesMoved:touches withEvent:event View:self];
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_delegate != nil) {
        [_delegate touchesCancelled:touches withEvent:event View:self];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_delegate != nil) {
        [_delegate touchesEnded:touches withEvent:event View:self];
    }
}


@end

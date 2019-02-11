//
//  MyPageContainerView.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 7. 24..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "MyPageContainerView.h"

@implementation MyPageContainerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"subMyinfoViewController"]) {
        //segue.destinationViewController;
    }
}

@end

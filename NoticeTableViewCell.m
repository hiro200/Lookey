//
//  NoticeTableViewCell.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 13..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)noticeBtnPressed:(id)sender {
	[self.delegate selectNotice: self.index bSelected: self.selected];
}

@end

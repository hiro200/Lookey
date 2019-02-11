//
//  NoticeTableViewCell.h
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 13..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeTableDelegate <NSObject>

- (void) selectNotice: (int) index bSelected: (BOOL) bSelected;

@end

@interface NoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *noticeBtn;
@property (weak, nonatomic) IBOutlet UIView *noticeDetailView;
@property (weak, nonatomic) IBOutlet UILabel *noticeContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noticeContentImageView;
@property (weak, nonatomic) IBOutlet UIView *imageBottomLineView;

@property (nonatomic, assign) int index;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, assign) id<NoticeTableDelegate> delegate;

@end

//
//  NationInfoCollectionViewCell.h
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 13..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NationInfoDelegate <NSObject>

- (void) selectNation: (NSString*) nationCode;

@end

@interface NationInfoCollectionViewCell : UICollectionViewCell

// @property (weak, nonatomic) IBOutlet UIImageView *nationImageView;
@property (weak, nonatomic) IBOutlet UIButton *nationSelectionBtn;

@property (nonatomic, strong) NSString *nationCode;
@property (nonatomic, assign) id<NationInfoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *nationImageView;

@end

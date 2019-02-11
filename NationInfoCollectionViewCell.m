//
//  NationInfoCollectionViewCell.m
//  Lookey
//
//  Created by 준구 황 on 2015. 5. 13..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "NationInfoCollectionViewCell.h"

@implementation NationInfoCollectionViewCell

- (IBAction)selectNationBtnPressed:(id)sender {
	if (self.nationSelectionBtn.selected)
		return;
	[self.delegate selectNation: self.nationCode];
}


@end

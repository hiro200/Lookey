//
//  MainPanelController.h
//  Lookey
//
//  Created by jg.hwang on 2015. 4. 26..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "JASidePanelController.h"

typedef enum{
	kMenu_Notice,
	kMenu_MyPage,
	kMenu_Gallery,
	kMenu_Lucky,
	kMenu_StoreNetwork,
	kMenu_Setting,
	kMenu_Guide,
    kMenu_Open,
    kMenu_None
} eMenu;

@interface MainPanelController : JASidePanelController

@end

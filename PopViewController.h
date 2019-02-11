//
//  PopViewController.h
//  Lookey
//
//  Created by nexbiz-korea on 2015. 12. 7..
//  Copyright © 2015년 comants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *price;

@end

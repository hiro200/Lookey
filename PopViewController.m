//
//  PopViewController.m
//  Lookey
//
//  Created by nexbiz-korea on 2015. 12. 7..
//  Copyright © 2015년 comants. All rights reserved.
//

#import "PopViewController.h"
#import "ImageSearchResultViewController.h"
#import "ImageSearchResultManager.h"

#import "CarbonKit.h"
#import <math.h>

#import "AppDataManager.h"
#import "GlobalValues.h"
#import "NSDictionary+Object.h"
#import "CommonUtils.h"
#import "HttpRespons.h"


@interface PopViewController ()
{
    CarbonSwipeRefresh *refresh;
    
    NSArray* entries;
    NSDictionary *dicResult;
    NSDictionary *firstItem;
}
@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    refresh = [[CarbonSwipeRefresh alloc] initWithScrollView:self.tableView];
    [refresh setMarginTop:0];
    [refresh setColors:@[[UIColor blueColor], [UIColor redColor], [UIColor orangeColor], [UIColor greenColor]]];
    [self.view addSubview:refresh];
    
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
    AppDataManager *adm = [AppDataManager appDataManager];
    NSString *server = [NSString stringWithFormat:@"%@/xml/lk_get_shoppingmall.php", adm.SERVER_IP];
    
    
    NSString *szBody = [NSString stringWithFormat:@"img_code=%@&mall_type=%d&order_type=%d&start=%d&limit=%d&language_code=%@",
                        GLOBAL_VALUES.ImageSearchResultId,0,1,0,100,
                        [CommonUtils getLanguageCode]];
    
    
    GLOBAL_VALUES.dicImgSearchResult = [HttpRespons HttpResponsWithURLString:server data:[szBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    dicResult = GLOBAL_VALUES.dicImgSearchResult;
    entries = [dicResult valueForKeyPath:@"malls"];
    
    
    ///////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 20;
    return [entries count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    if(indexPath.row % 2){
        
        [cell setBackgroundColor:[UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1.0f]];
    }else{
        cell.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:255.0/255 alpha:0.8f];
        
    }
    
    // cell.textLabel.text = [NSString stringWithFormat:@"   Cell %d ", (int)indexPath.row];
    // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    // cell.detailTextLabel.text = [NSString stringWithFormat:@"Mr. Disney"];
    
    
    /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    //[label setFont: [UIFont systemFontOfSize:11.0f ]];
    
    
    NSLog(@"Path = %d", (int)indexPath.row);
    
    NSArray *viewsToRemove1 = [cell.contentView subviews];
    for (UIView *v in viewsToRemove1)
    {
        
        if (v.tag == 111111) {
            [v removeFromSuperview];
        }
    }
    
    /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////
    
    firstItem = [entries objectAtIndex:(int)indexPath.row];
    NSString *product_name = [firstItem objectForKey:@"mall_product_name"];
    // limit = [dicResult intForKey:@"limit"];
    
    NSString *resultid = [dicResult StringForKey:@"results"];
    
    //    NSLog(@"Mall_info = %@", entries);
    NSLog(@"Result = %@", resultid);
    NSLog(@"PName = %@", product_name);
    
    
    //    NSDictionary *descItem = [entries objectAtIndex:(int)indexPath.row];
    NSString *product_desc = [firstItem objectForKey:@"mall_product_desc"];
    
    NSLog(@"pDescript = %@", product_desc);
    
    
    //    NSDictionary *priceItem = [entries objectAtIndex:(int)indexPath.row];
    NSString *product_price = [firstItem objectForKey:@"mall_product_price"];
    
    
    NSString *mall_image = [firstItem objectForKey:@"mall_icon"];
    
    NSLog(@"MALL NAME = %@", mall_image);
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////table Cell 이미지 사용 //////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    if([mall_image isEqualToString:@"gmarket"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"gmarket_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"emart"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"emart_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"11st"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"11st_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"auction"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"auction_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"interpark"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"interpark_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"homeplus"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"homeplus_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"lottemart"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"lotte_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"coupang"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"coupang_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"ticketmonster"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"tmon_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"coocha"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"coocha_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"wemakeprice"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"wemp_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"shinsegaemall"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"shinsegae_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"gsshop"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"gsshop_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }else if([mall_image isEqualToString:@"other"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"etc_mall_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }
    
    else if([mall_image isEqualToString:@"post"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"post_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }
    
    else if([mall_image isEqualToString:@"ak"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"ak_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }
    
    else if([mall_image isEqualToString:@"nh"]){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.image = [UIImage imageNamed:@"nh_s.png"];
        imageView.tag = 111111;
        [cell.contentView addSubview:imageView];
    }

    
    else{
        cell.imageView.image = nil;
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////table Cell Label 사용 //////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Goods name
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 140, 30)];
    //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = [NSString stringWithFormat:@"%@", product_name];
    label.tag = 111111;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0f];
    [label setFont: [UIFont systemFontOfSize:14.0f ]];
    [cell.contentView addSubview:label];
    
    
//////////////////////////////////////////////////////
    // Price label
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@"."];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    
    UILabel *plabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 22, 100, 30)];
    //    plabel.text = [NSString stringWithFormat:@"%@",  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:4858934.3557]]];
    plabel.text = [NSString stringWithFormat:@"%@", product_price];
    plabel.tag = 111111;
    plabel.textAlignment = NSTextAlignmentRight;
    plabel.textColor = [UIColor colorWithRed:241.0/255 green:95.0/255 blue:85.0/255 alpha:1.0f];
    [plabel setFont: [UIFont systemFontOfSize:14.0f ]];
    [cell.contentView addSubview:plabel];
    
/////////////////////////////////////////////////////////
    //부가설명 레이블
    if(indexPath.row || indexPath.row == 0){
        //   label.text = [NSString stringWithFormat:@"피규어 공짜"];
        UILabel *desclabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 140, 30)];
        desclabel.text = [NSString stringWithFormat:@"%@", product_desc];
        desclabel.tag = 111111;
        desclabel.textAlignment = NSTextAlignmentLeft;
        desclabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0f];
        [desclabel setFont: [UIFont systemFontOfSize:11.0f ]];
        [cell.contentView addSubview:desclabel];
        
    }else{
        //  label.text = @"대박 할인";
        UILabel *desclabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 32, 140, 30)];
        desclabel.text = [NSString stringWithFormat:@""];
        desclabel.tag = 111111;
        desclabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:desclabel];
    }
    
    
    /////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    firstItem = [entries objectAtIndex:(int)indexPath.row];
    NSString *product_url = [firstItem objectForKey:@"mall_product_url"];
    
    NSLog(@"pURL = %@", product_url);
    NSLog(@"IndexPath = %d", (int)indexPath.row);
    
    [CommonUtils loadWeb: product_url withViewController: self isGotoMain:NO isCheckLookey:YES];
    
}

- (void)refresh:(id)sender {
    NSLog(@"REFRESH");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

- (void)endRefreshing {
    [refresh endRefreshing];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

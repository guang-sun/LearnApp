//
//  TrainAboutOurViewController.m
//  KindeeTrain
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainAboutOurViewController.h"

@interface TrainAboutOurViewController ()

@end

@implementation TrainAboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"关于我们";
    
    UIImageView  *bgimageView =[[UIImageView alloc]init];
    [bgimageView setBackgroundColor:[UIColor whiteColor]];
    //    bgimageView.image =[UIImage imageNamed:@"menu_bg_1136"];
    [self.view addSubview:bgimageView];
    bgimageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
    //    self.view.backgroundColor =[UIColor groupTableViewBackgroundColor];
    UIImageView  *imageView =[[UIImageView alloc]init];
    imageView.backgroundColor =[UIColor grayColor];
    imageView.image =[UIImage imageNamed:@"403.png"];
    imageView.layer.cornerRadius =10.0f;
    imageView.layer.masksToBounds =YES;
    [bgimageView addSubview:imageView];
    
    
    
    UILabel  *versionLabel =[[UILabel alloc]init];
    versionLabel.textAlignment =NSTextAlignmentCenter;
    versionLabel.textColor =[UIColor blackColor];
    
    versionLabel.text = [NSString stringWithFormat:@"学佳\n当前版本 v%@",TrainAPPVersions];
    [bgimageView addSubview:versionLabel];
    
    
    UIImageView  *twocodeimageView =[[UIImageView alloc]init];
    twocodeimageView.image =[UIImage imageNamed:@"two_code"];
    //    [bgimageView addSubview:twocodeimageView];
    
    
    //    UILabel *inLabel =[[UILabel alloc]init];
    //    inLabel.textAlignment =NSTextAlignmentCenter;
    //    inLabel.textColor =[UIColor blackColor];
    //    inLabel.numberOfLines =0;
    //    inLabel.font =[UIFont systemFontOfSize:12];
    //    [bgimageView addSubview:inLabel];
    
    imageView.sd_layout.centerXEqualToView(bgimageView).widthIs(60).centerYIs(TrainSCREENWIDTH/2-100).heightEqualToWidth();
    versionLabel.sd_layout.centerXEqualToView(bgimageView).widthIs(120).topSpaceToView(imageView,10).autoHeightRatio(0);


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

//
//  TrainSetUPViewController.m
//   KingnoTrain
//
//  Created by apple on 16/12/6.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainSetUPViewController.h"
#import "TrainLoginViewController.h"
#import "TrainAboutOurViewController.h"
#import "TrainSuggestViewController.h"

//#import <PgyUpdate/PgyUpdateManager.h>


@interface TrainSetUPViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView         *userIconImageV;
    UILabel             *userNameLab,*userJObLab,*userCouserLab,*userLearnTimeLab;
    UILabel             *cleanCacheLab;
    UILabel             *versionLabel;
    
    UILabel             *courseLabel;
    UILabel             *timeLabel ;
    
    UIView              *bgView;
    NSArray             *setUpArr;
    NSArray             *setUpImageArr;
    UIScrollView        *bgScrollV;
    BOOL                status;
    UISwitch            *selectSwitch;
    UITableView         *setUpTableV;
    
    NSDictionary        *infoDic ;
}


@end

@implementation TrainSetUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置" ;
    
    bgScrollV =[[UIScrollView alloc]init];
    bgScrollV.showsVerticalScrollIndicator =NO;
    bgScrollV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bgScrollV];
    [self creatUserInfoView];
    [self creatSetUPTableView];

    // Do any additional setup after loading the view.
}

-(void)creatUserInfoView{
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor =[UIColor whiteColor];
    
    [bgScrollV addSubview:bgView];
    
    NSLog(@"%@",NSHomeDirectory())
    ;
    userIconImageV =[[UIImageView alloc]init];
    userIconImageV.layer.cornerRadius =trainAutoLoyoutImageSize(trainIconWidth)/2;
    userIconImageV.layer.masksToBounds =YES;
    userIconImageV.layer.borderWidth =1.0f;
    userIconImageV.layer.borderColor = TrainNavColor.CGColor;
    userIconImageV.image =[UIImage imageNamed:@"user_avatar_default"];
    
    userNameLab = [[UILabel alloc]initCustomLabel];
    userNameLab.textColor = TrainColorFromRGB16(0xFF8608);
    userNameLab.cusFont =(14.0f);
    
    userJObLab =[[UILabel alloc]initCustomLabel];
    userJObLab.textColor = TrainColorFromRGB16(0x7C7C7C);
    userJObLab.cusFont =(12.0f);
    
    
    UIView  *lineV =[[UIView alloc]init];
    lineV.backgroundColor = TrainColorFromRGB16(0xD2D2D2);
    
    //    UIImageView *couseIcon =[[UIImageView alloc]init];
    //    couseIcon.image =[UIImage imageThemeColorWithName:@"Train_LearningCouse"];
    //
    //    userCouserLab =[[UILabel alloc]creatTitleLabel];
    //    userCouserLab.cusFont= (12.f);
    ////    userCouserLab.textColor = TrainColorFromRGB16(0x474747);
    //
    //    UIImageView *learnTimeIcon =[[UIImageView alloc]initWithImage:[UIImage imageThemeColorWithName:@"Train_LearningTime"]];
    //
    //    userLearnTimeLab =[[UILabel alloc]creatTitleLabel];
    //    userLearnTimeLab.cusFont= (12.f);
    ////    userLearnTimeLab.textColor = TrainColorFromRGB16(0x474747);
    
    
    UIView *lineV1 =[[UIView alloc]initWithLine1View];
    
    //    couseIcon,userCouserLab,lineV1,learnTimeIcon,userLearnTimeLab
    [bgView sd_addSubviews:@[userIconImageV,userNameLab,userJObLab,lineV]];
    UIView *supView =bgView;
    
    bgView.sd_layout
    .leftSpaceToView(bgScrollV,0)
    .rightEqualToView(bgScrollV)
    .topEqualToView(bgScrollV);
    
    userIconImageV.sd_layout
    .leftSpaceToView(supView,30)
    .topSpaceToView(supView,15)
    .widthIs(trainAutoLoyoutImageSize(trainIconWidth))
    .heightEqualToWidth();
    
    userNameLab.sd_layout
    .leftSpaceToView(userIconImageV,20)
    .topEqualToView(userIconImageV)
    .rightSpaceToView(supView,30)
    .heightIs(trainAutoLoyoutTitleSize(25));
    
    userJObLab.sd_layout
    .leftSpaceToView(userIconImageV,20)
    .topSpaceToView(userNameLab,0)
    .rightSpaceToView(supView,30)
    .heightIs(trainAutoLoyoutTitleSize(25));
    
    lineV.sd_layout
    .leftSpaceToView(supView,0)
    .topSpaceToView(userIconImageV,10)
    .rightSpaceToView(supView,0)
    .heightIs(0.5);
    
    lineV1.sd_layout
    .centerXEqualToView(supView)
    .widthIs(0.5)
    .topSpaceToView(lineV,(5))
    .heightIs(trainAutoLoyoutTitleSize(30));
    
    //    userCouserLab.sd_layout
    //    .rightEqualToView(lineV1)
    //    .topSpaceToView(lineV,10)
    //    .widthIs((120))
    //    .heightIs(trainAutoLoyoutTitleSize(20));
    //
    //    couseIcon.sd_layout
    //    .rightSpaceToView(userCouserLab,10)
    //    .topSpaceToView(lineV,10)
    //    .widthIs(trainAutoLoyoutTitleSize(20))
    //    .heightEqualToWidth();
    //
    //    learnTimeIcon.sd_layout
    //    .leftSpaceToView(lineV1,(25))
    //    .topSpaceToView(lineV,10)
    //    .widthIs(trainAutoLoyoutTitleSize(20))
    //    .heightEqualToWidth();
    //
    //    userLearnTimeLab.sd_layout
    //    .leftSpaceToView(learnTimeIcon,(10))
    //    .topSpaceToView(lineV,10)
    //    .rightSpaceToView(supView ,(20))
    //    .heightIs(trainAutoLoyoutTitleSize(20));
    
    [bgView setupAutoHeightWithBottomView:lineV bottomMargin:0];
    
    
    
    //   TOPMYCENTER
    [self downLoadCenterDate];
    
}
-(void)downLoadCenterDate{

    [[TrainNetWorkAPIClient client] trainGetUserCenterWithUser_id:TrainUser.user_id Success:^(NSDictionary *dic) {
        [self updateUI:dic[@"obj"]];
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
}
-(void)updateUI:(NSDictionary *)dic{
    
    infoDic = dic ;
    NSString  *imageStr =(dic[@"sphoto"])?dic[@"sphoto"]:@"";
    NSString  *imageURL =[TrainIP stringByAppendingString:imageStr];
    
    [userIconImageV sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"user_avatar_default"] options:SDWebImageAllowInvalidSSLCertificates];
    
    userNameLab.text =dic[@"full_name"];
    userJObLab.text =dic[@"group_name"];
    
    courseLabel.text =[NSString stringWithFormat:@"%@",infoDic[@"courseCount"]];
    timeLabel.text =[NSString stringWithFormat:@"%@",infoDic[@"courseTimes"]];
    
}
-(void)creatSetUPTableView{
    setUpArr =@[@[@"已学课程",@"已学时长"],@[@"非WIFI 视频可以播放/下载",@"意见反馈"],@[@"清除缓存",@"关于我们"]];
    setUpImageArr =@[@[@"Train_LearningCouse",@"Train_LearningTime"],@[@"Train_Setup_Wift",@"Train_Setup_Suggest",@"Train_Setup_Update"],@[@"Train_Setup_Clean",@"Train_Setup_AboutOur",@"Train_Setup_iPhone"]];
    setUpTableV =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    setUpTableV.delegate =self;
    setUpTableV.dataSource =self;
    setUpTableV.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 0.01)];
    setUpTableV.tableHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 0.01)];
    [setUpTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SETUPCell"];
    setUpTableV.bounces =NO;
    setUpTableV.sectionHeaderHeight =0.01;
    setUpTableV.sectionFooterHeight = 15;
    [bgScrollV addSubview:setUpTableV];
    
    
    __block float  count = 0;
    [setUpArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray  *arr = obj;
        count += arr.count;
    }];
    
    setUpTableV.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(bgView,0)
    .heightIs(44 * count +  15 * (setUpArr.count + 1 ));
    
    UIButton  *button =[[UIButton alloc]initCustomButton];
    button.cusTitleColor =[UIColor redColor];
    button.backgroundColor =[UIColor whiteColor];
    button.cusTitle =@"退出登录";
    [button addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollV addSubview:button];
    
    button.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(setUpTableV,0)
    .heightIs((50));
    
    bgScrollV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(TrainNavorigin_y + 0 , 0,   5, 0));
    [bgScrollV setupAutoContentSizeWithBottomView:button bottomMargin:10];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return setUpArr.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < setUpArr.count ) {
        
        NSArray *arr =setUpArr[section];
        
        return arr.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SETUPCell"];
    
    for (UIView  *view  in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    NSArray *arr =setUpArr[indexPath.section];
    NSArray *imageArr =setUpImageArr[indexPath.section];
    UIImageView  *imageView =[[UIImageView alloc]init];
    
    if (indexPath.section == 0) {
        
        imageView.image = [UIImage imageThemeColorWithName:imageArr[indexPath.row]];
        
    }else {
        
        imageView.image =[UIImage imageNamed:imageArr[indexPath.row]];
        
    }
    
    [cell.contentView addSubview:imageView];
    
    imageView.sd_layout
    .leftSpaceToView(cell.contentView,10)
    .centerYEqualToView(cell.contentView)
    .widthIs(20)
    .heightIs(20);
    
    UILabel  *lable =[[UILabel alloc]initCustomLabel];
    lable.text =arr[indexPath.row];
    lable.cusFont =13.f;
    lable.textColor =TrainColorFromRGB16(0x474747);
    
    [cell.contentView addSubview:lable];
    
    
    lable.sd_layout
    .leftSpaceToView(imageView,10)
    .centerYEqualToView(cell.contentView)
    .rightSpaceToView(cell.contentView,50)
    .heightIs(20);
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        selectSwitch =[[UISwitch alloc]init];
        [cell.contentView addSubview:selectSwitch];
        
        NSDictionary *dic =[TrainUserDefault objectForKey:TrainAllowWWANPlayer];
        status =(dic[TrainUser.user_id])?[dic[TrainUser.user_id] boolValue]:NO;
        selectSwitch.on =status;
        [selectSwitch addTarget:self action:@selector(setUpDownload:) forControlEvents:UIControlEventValueChanged];
        selectSwitch.sd_layout
        .rightSpaceToView(cell.contentView,15)
        .centerYEqualToView(cell.contentView);
        
    }else if(indexPath.section == 2 && indexPath.row == 0){
        
        cleanCacheLab =[[UILabel  alloc]initCustomLabel];
        cleanCacheLab.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:cleanCacheLab];
        cleanCacheLab.sd_layout
        .rightSpaceToView(cell.contentView,15)
        .centerYEqualToView(cell.contentView)
        .widthIs(100)
        .heightIs((20));
        cleanCacheLab.text = getCacheSize();
        
    }else if (indexPath.section == 1 && indexPath.row == 2 ) {
        
        versionLabel =[[UILabel  alloc]initCustomLabel];
        versionLabel.textAlignment =NSTextAlignmentRight;
        [cell.contentView addSubview:versionLabel];
        versionLabel.sd_layout
        .rightSpaceToView(cell.contentView,15)
        .centerYEqualToView(cell.contentView)
        .widthIs(100)
        .heightIs((20));
        versionLabel.text =[NSString stringWithFormat:@"v%@",TrainAPPVersions];
        
    }else if(indexPath.section == 0 ){
        
        if (indexPath.row == 0 ) {
            
            courseLabel =[[UILabel  alloc]initCustomLabel];
            courseLabel.textAlignment =NSTextAlignmentRight;
            [cell.contentView addSubview:courseLabel];
            courseLabel.sd_layout
            .rightSpaceToView(cell.contentView,15)
            .centerYEqualToView(cell.contentView)
            .widthIs(100)
            .heightIs((20));
            
            if(infoDic[@"courseCount"] && ![infoDic[@"courseCount"] isEqualToString:@""]){
               
                courseLabel.text =[NSString stringWithFormat:@"%@",infoDic[@"courseCount"]];

            }else {
                courseLabel.text = @"";

            }
            
            
        }else if (indexPath.row == 1 ){
            
            timeLabel =[[UILabel  alloc]initCustomLabel];
            timeLabel.textAlignment =NSTextAlignmentRight;
            [cell.contentView addSubview:timeLabel];
            timeLabel.sd_layout
            .rightSpaceToView(cell.contentView,15)
            .centerYEqualToView(cell.contentView)
            .widthIs(100)
            .heightIs((20));
            
            if(infoDic[@"courseTimes"] && ![infoDic[@"courseTimes"] isEqualToString:@""]){
                
                timeLabel.text =[NSString stringWithFormat:@"%@",infoDic[@"courseTimes"]];
                
            }else {
                timeLabel.text = @"";
                
            }
        }
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    return cell;
    
}
-(void)setUpDownload:(UISwitch *)swit{
    [self chooseSelectSwitch:swit.on];
    
    
}
-(void)chooseSelectSwitch:(BOOL)choose{
    
    
    if (choose) {
        [TrainAlertTools showAlertWith:self title:@"网络提示" message:@"使用移动网络观看或下载视频会消耗较多流量.确认要开启吗?" callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 0) {
                
                status =NO;
                selectSwitch.on =status;
                
            }else if(btnIndex ==1){
                
                NSDictionary  *saveDic =[NSDictionary dictionaryWithObjectsAndKeys:@(YES),TrainUser.user_id,nil];
                [TrainUserDefault setObject:saveDic forKey:TrainAllowWWANPlayer];
                [TrainUserDefault synchronize];
                status =YES;
                selectSwitch.on =status;

            }
            
        } cancelButtonTitle:@"取消" destructiveButtonTitle:@"开启" otherButtonTitles:nil, nil];
        
    }else{
        
        status =NO;
        selectSwitch.on =status;
        NSDictionary  *saveDic =[NSDictionary dictionaryWithObjectsAndKeys:@(NO),TrainUser.user_id ,nil];
        [TrainUserDefault setObject:saveDic forKey:TrainAllowWWANPlayer];
        [TrainUserDefault synchronize];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                [self chooseSelectSwitch:!status];
            }
                break;
            case 1:
                [self.navigationController pushViewController:[TrainSuggestViewController new] animated:YES];
                break;
            case 2:
//                [self trainShowHUDOnlyActivity];
//                [self bigupdate];
//                
//                break;
            default:
                break;
        }
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                
                [self cacheClean:indexPath];
                break;
            case 1:
                
                [self.navigationController  pushViewController:[TrainAboutOurViewController new] animated:YES ];
                break;
            case 2:
                
                break;
            default:
                break;
        }
        
    }
    
}


-(void)cacheClean:(NSIndexPath *)indexPath{
    UIAlertController  *alertVC =[UIAlertController alertControllerWithTitle:@"缓存清理" message:@"清理缓存会删除本应用缓存的图片和数据,请谨慎清理" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"清理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        cleanCacheSize();

        [self trainShowHUDOnlyText:@"缓存已清理" andoff_y:100.0f];
        [setUpTableV  reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }]];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}
-(void)cancelLogin{
    
    TrainWeakSelf(self);
    [TrainAlertTools showAlertWith:self title:@"提示" message:@"是否注销用户" callbackBlock:^(NSInteger btnIndex) {
        
        if (btnIndex == 1) {
            [weakself trainShowHUDOnlyActivity];
            [TrainUserDefault setObject:@"2" forKey:@"LOGINSTATUS"];
            [TrainUserDefault synchronize];
            [TrainUserInfo ResetData:TrainUser];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakself trainHideHUD];
                
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                app.window.rootViewController =[TrainLoginViewController new];
            });

        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
}



//-(void)APPupdate:(NSDictionary *)dic{
//    NSLog(@"setup update ==%@",dic);
//    if (dic) {
//        [self trainHideHUD];
//        NSString *version =[NSString stringWithFormat:@"发现新版本 v%@",dic[@"versionCode"]];
//        UIAlertController  *alertVC =[UIAlertController alertControllerWithTitle:version message:dic[@"releaseNote"] preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"忽略此版本" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
//        [alertVC addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"downloadURL"]]];
//            //            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
//            
//        }]];
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }else{
//        [self trainShowHUDOnlyText:@"已是最新版本"];
//       
//    }
//}

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

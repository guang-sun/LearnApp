//
//  TrainIntroductionViewController.m
//  KindeeTrain
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainIntroductionViewController.h"
#import "TrainUnfoldView.h"

@interface TrainIntroductionViewController ()
{
    UILabel                         *courseTitleLab, *learnNumLab, *courseGradeLab,
                                    *peopleContentLab, *tagertContentLab;
    TrainUnfoldView                 *courseGaiContentLab;
    

}
@end

@implementation TrainIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view .backgroundColor =[UIColor  whiteColor];
  

    
    [self creatIntroductionView];
    // Do any additional setup after loading the view.
}

-(void)creatIntroductionView{
   
    [self.view addSubview:self.introScrollView];
    
    learnNumLab =[[UILabel alloc]creatContentLabel];
    //    learnNumLab.textAlignment = NSTextAlignmentCenter;
    [self.introScrollView addSubview:learnNumLab];
    
    courseGradeLab =[[UILabel alloc]creatContentLabel];
    courseGradeLab.textAlignment = NSTextAlignmentCenter;
    [self.introScrollView addSubview:courseGradeLab];
    
    
    UIView   *line1 =[[UIView alloc]init];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.introScrollView addSubview:line1];
    
    UILabel  *courseGailanLab = [[UILabel alloc]creatTitleLabel];
    courseGailanLab.text = @"课程概述";
    [self.introScrollView addSubview:courseGailanLab];
    
    courseGaiContentLab =[[TrainUnfoldView alloc]initWithMaxHeight:3];
    [self.introScrollView addSubview:courseGaiContentLab];
    
    UILabel  *peopleLab = [[UILabel alloc]creatTitleLabel];
    peopleLab.text = @"适用人群";
    [self.introScrollView addSubview:peopleLab];
    
    peopleContentLab =[[UILabel alloc]creatContentLabel];
    [self.introScrollView addSubview:peopleContentLab];
    
    UIView   *line2 =[[UIView alloc]init];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.introScrollView addSubview:line2];
    
    UILabel  *tagertLab = [[UILabel alloc]creatTitleLabel];
    tagertLab.text = @"学习目标";
    [self.introScrollView addSubview:tagertLab];
    
    tagertContentLab =[[UILabel alloc]creatContentLabel];
    [self.introScrollView addSubview:tagertContentLab];
    
    
    self.introScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
    learnNumLab.sd_layout
    .leftSpaceToView(self.introScrollView,TrainMarginWidth)
    .topSpaceToView(self.introScrollView,10)
    .widthIs(100)
    .heightIs(15);
    
    
    courseGradeLab.sd_layout
    .leftSpaceToView(learnNumLab,10)
    .topEqualToView(learnNumLab)
    .widthIs(100)
    .heightRatioToView(learnNumLab,1);
    
    line1.sd_layout
    .leftSpaceToView(self.introScrollView,0)
    .rightSpaceToView(self.introScrollView,0)
    .topSpaceToView(learnNumLab,10)
    .heightIs(10);
    
    courseGailanLab.sd_layout
    .leftSpaceToView(self.introScrollView ,TrainMarginWidth)
    .topSpaceToView(line1,TrainMarginWidth)
    .widthIs(100)
    .heightIs(20);
    
    courseGaiContentLab.sd_layout
    .leftSpaceToView(self.introScrollView,0)
    .topSpaceToView(courseGailanLab,10)
    .rightSpaceToView(self.introScrollView,0);
    
    peopleLab.sd_layout
    .leftSpaceToView(self.introScrollView ,TrainMarginWidth)
    .topSpaceToView(courseGaiContentLab,10)
    .widthIs(100)
    .heightIs(20);
    
    peopleContentLab.sd_layout
    .leftSpaceToView(self.introScrollView ,TrainMarginWidth)
    .rightSpaceToView(self.introScrollView,TrainMarginWidth)
    .topSpaceToView(peopleLab,10)
    .autoHeightRatio(0);
    
    line2.sd_layout
    .leftSpaceToView(self.introScrollView,TrainMarginWidth)
    .rightSpaceToView(self.introScrollView,TrainMarginWidth)
    .topSpaceToView(peopleContentLab,10)
    .heightIs(0.7);
    
    tagertLab.sd_layout
    .leftSpaceToView(self.introScrollView ,TrainMarginWidth)
    .topSpaceToView(line2,10)
    .widthIs(100)
    .heightIs(20);
    
    tagertContentLab.sd_layout
    .leftSpaceToView(self.introScrollView ,TrainMarginWidth)
    .rightSpaceToView(self.introScrollView,TrainMarginWidth)
    .topSpaceToView(tagertLab,10)
    .autoHeightRatio(0);
    
    //    [self updateCourseInfo:coursIntroDic];
    [self.introScrollView setupAutoContentSizeWithBottomView:tagertContentLab bottomMargin:10];

}

-(void)updateDataWith:(NSDictionary *)infoDic{
    
    NSDictionary  *introDic = infoDic;
    learnNumLab.text = [NSString stringWithFormat:@"%d 人学过",[introDic[@"study_num"] intValue]];
    courseGradeLab.text = [NSString stringWithFormat:@"%d 星评价",[introDic[@"grade"] intValue]];
    
//    [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"introduction"]]
//    [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"forPerson"]]
//    [TrainStringUtil trainReplaceHtmlCharacter:introDic[@"studyTarget"]]
    
    NSString  *gaiContentText = TrainStringIsEmpty(introDic[@"introduction"])?@"暂无":introDic[@"introduction"];
    courseGaiContentLab.text = gaiContentText;

    NSString  *peopleContentText =TrainStringIsEmpty(introDic[@"forPerson"])?@"暂无":introDic[@"forPerson"];
    peopleContentLab.text = peopleContentText;

    NSString  *tagertContentText =TrainStringIsEmpty(introDic[@"studyTarget"])?@"暂无":introDic[@"studyTarget"];
    tagertContentLab.text = tagertContentText;
//        tagertContentLab.text = @"jhsgdhagshd /n ah \n sgdhagsh\ndghas/nashdjhagsdhg/nsjhs\ngdhagshd/nahsgdhag\nshdghas/nashdjh\nagsdhg/nsjhsgdhagshd/na\nhsgdhag\nshdghas/nashd\njhagsdhg/nsjhsgdha\ngshd/nahsgdh\nagshdghas/nashdjh\nagsdhg/nsj\nhsgdhagshd/nahsg\ndhagshdghas/nashdjh\nagsdhg/nsjhsgd\nhagshd/nahsgdhagshdghas/nashdjhagsdhg/nsjhsgdhag\nshd/na\nhsgdhagsh\ndghas/\nnashdjhagsdhg/nsjhsgdh\nagshd/nahsgdhagshdghas/nashdjhagsdhg/nsasahdghas/nashdjh\nagsdhg/nsjhsgdhagshd/na\nhsgdhag\nshdghas/nashd\njhagsdhg/nsjhsgdha\ngshd/nahsgdh\nagshdghas/nashdjh\nagsdhg/nsj\nhsgdhagshd/nahsg\ndhagshdghas/nashdjh\nagsdhg/nsjhsgd\nhagshd/nahsgdhagshdghas/nashdjhagsdhg/nsjhsgdhag\nshd/na\nhsgdhagsh\ndghas/\nnashdjhagsdhg/nsjhsgdh\nagshd/nahsgdhagshdghas/nashdjhagsdhg/nsasahdghas/nashdjh\nagsdhg/nsjhsgdhagshd/na\nhsgdhag\nshdghas/nashd\njhagsdhg/nsjhsgdha\ngshd/nahsgdh\nagshdghas/nashdjh\nagsdhg/nsj\nhsgdhagshd/nahsg\ndhagshdghas/nashdjh\nagsdhg/nsjhsgd\nhagshd/nahsgdhagshdghas/nashdjhagsdhg/nsjhsgdhag\nshd/na\nhsgdhagsh\ndghas/\nnashdjhagsdhg/nsjhsgdh\nagshd/nahsgdhagshdghas/nashdjhagsdhg/nsasa";
//
    
}


-(UIScrollView *)introScrollView{
    if (!_introScrollView) {
        
        _introScrollView = [[UIScrollView alloc]init];
        _introScrollView.showsVerticalScrollIndicator = NO;
    }
    return  _introScrollView;
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

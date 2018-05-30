//
//  TrainAddAppraiseViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainAddAppraiseViewController.h"
#import "TrainCustomTextView.h"

@interface TrainAddAppraiseViewController ()<UITextViewDelegate>
{
    UIButton            *rightBtn;
    UIView              *starbgView;
    NSMutableArray      *btnMuArr;
    TrainCustomTextView *appraiseTextView;
    UILabel             *noteLimitLab;
    
    NSString            *grade;
    
}
@end

@implementation TrainAddAppraiseViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
    [appraiseTextView becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    grade = @"0";
    btnMuArr =[NSMutableArray array];
    self.navigationItem.title  = @"添加评价";

    
    rightBtn =[[UIButton alloc]initCustomButton];
    rightBtn.cusTitle = @"提交";
    rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    [rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    rightBtn.selected = NO;
    rightBtn.userInteractionEnabled = NO;
    [rightBtn addTarget:self action:@selector(saveAppraise)];
//    [self.navBar creatRightBarItem:rightBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self creatApraiseView];
    
    // Do any additional setup after loading the view.
}

-(void)creatApraiseView{
    
    starbgView = [[UIView alloc]init];
    [self.view addSubview:starbgView];
    
    starbgView.sd_layout
    .centerXEqualToView(self.view)
    .widthIs(230)
    .topSpaceToView(self.view, TrainNavorigin_y +10)
    .heightIs(40);
    
    UIButton  *lastBtn ;
    for (int i=0; i<5; i++)
    {
        UIButton  *starBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [starBtn setImage:[UIImage imageNamed:@"star_big"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"star_big_selected"] forState:UIControlStateSelected];
        [starBtn setImage:[UIImage imageNamed:@"star_big"] forState:UIControlStateHighlighted];
        [starBtn setImage:[UIImage imageNamed:@"star_big_selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
        starBtn.tag =i;
        [starBtn addTarget:self action:@selector(selectorStar:) forControlEvents:UIControlEventTouchUpInside];
        [starbgView addSubview:starBtn];
        if (i == 0) {
            starBtn.sd_layout
            .leftSpaceToView(starbgView,0)  
            .topSpaceToView(starbgView,5)
            .widthIs((30))
            .heightIs((30));
        }else{
            starBtn.sd_layout
            .leftSpaceToView(lastBtn,20)
            .topEqualToView(lastBtn)
            .widthIs((30))
            .heightIs((30));
        }
        lastBtn =starBtn;
        [btnMuArr addObject:starBtn];
    }

    appraiseTextView=[[TrainCustomTextView alloc]init];
    appraiseTextView.font=[UIFont systemFontOfSize:16.0f];
    appraiseTextView.placeholder=@"请输入你的评价";
    appraiseTextView.delegate = self;
    [appraiseTextView setAlwaysBounceVertical:YES];
    appraiseTextView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:appraiseTextView];
    
    __weak  typeof(rightBtn)WeakRight = rightBtn;
    appraiseTextView.textViewChangeBlock = ^(NSString *text){
        if (text.length > 0) {
            WeakRight.selected = YES;
            WeakRight.userInteractionEnabled = YES;
        }else{
            WeakRight.selected = NO;
            WeakRight.userInteractionEnabled = NO;
        }
    };
    
    //    noteTextView.sd_layout
    //    .leftSpaceToView(self.view,10)
    //    .rightSpaceToView(self.view,10)
    //    .topSpaceToView(self.view,hei)
    //    .bottomSpaceToView(self.view,scale(40));
    
    noteLimitLab=[[UILabel alloc]creatContentLabel];
    noteLimitLab.text=@"您还可输入500个字";
    noteLimitLab.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:noteLimitLab];
    
 
    
    appraiseTextView.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(starbgView,10)
    .bottomSpaceToView(self.view,40);
    
    
    
    noteLimitLab.sd_layout
    .rightEqualToView(appraiseTextView)
    .topSpaceToView(appraiseTextView,10)
    .widthIs(TrainSCREENWIDTH-20)
    .heightIs(20);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardFram:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(traintextDidChange) name:UITextViewTextDidChangeNotification object:self];
    
    
    
}
-(void)traintextDidChange{
    if (appraiseTextView.text.length > 0) {
        rightBtn.selected = YES;
        rightBtn.userInteractionEnabled = YES;
    }else{
        rightBtn.selected = NO;
        rightBtn.userInteractionEnabled = NO;
    }
}
-(void)selectorStar:(UIButton *)btn{
    grade = [NSString stringWithFormat:@"%zi",btn.tag + 1];
    for (UIButton *starBtn  in  btnMuArr ) {
        
        if (btn.tag >= starBtn.tag) {
            starBtn.selected =YES;
            
        }else{
            
            starBtn.selected =NO;
        }
    }
}


-(void)changeKeyboardFram:(NSNotification *)noti{
    NSDictionary  *info =[noti userInfo];
    CGSize  keyHeight =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        appraiseTextView.sd_layout
        .bottomSpaceToView(self.view,40+keyHeight.height);
        [appraiseTextView updateLayout];
    }];
    
    
}
-(void)KeyboardHide:(NSNotification *)noti{
    [UIView animateWithDuration:0.5 animations:^{
        
        appraiseTextView.sd_layout
        .bottomSpaceToView(self.view,40);
        [appraiseTextView updateLayout];
        
    }];
}

-(void)saveAppraise{
    
    if (grade==0)
    {
        [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"为此课程打个分" buttonTitle:@"去打分" buttonStyle:TrainAlertActionStyleCancel];
        return;
    }else if ([TrainStringUtil trainIsBlankString:appraiseTextView.text]){
       
         [TrainAlertTools showTipAlertViewWith:self title:@"提示" message:@"为此课程说两句" buttonTitle:@"说两句" buttonStyle:TrainAlertActionStyleCancel];
       
        return;
    }
    [appraiseTextView resignFirstResponder];
   
    [self saveAppraiseData];
}

-(void)saveAppraiseData{
    
    [self trainShowHUDOnlyActivity];
    
    NSMutableDictionary  *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:notEmptyStr(appraiseTextView.text) forKey:@"content"];
    [muDic setObject:notEmptyStr(grade)                 forKey:@"grade"];
    [muDic setObject:notEmptyStr(_infoDic[@"room_id"])  forKey:@"room_id"];
    [muDic setObject:notEmptyStr(_infoDic[@"type"])      forKey:@"type"];
    [muDic setObject:notEmptyStr(_infoDic[@"object_id"]) forKey:@"object_id"];


    
    [[TrainNetWorkAPIClient client] trainCourseAddAppraiseWithinfoDic:muDic Success:^(NSDictionary *dic) {
        
        if (dic) {
            
            if (self.delegate &&[self.delegate respondsToSelector:@selector(saveAppraiseSuccess:)]) {
                [self.delegate saveAppraiseSuccess:dic[@"comment"]];
            }
            
            [self trainShowHUDOnlyText:@"评价成功" andoff_y:150.0f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

        [self trainShowHUDOnlyText:@"评价失败" andoff_y:150.0f];

    }];
   
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length + text.length <= 500 || [text isEqualToString:@""]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSInteger   textLength =text.length;
            if (text.length == 0 && range.length > 0) {
                textLength = -range.length;
            }
            int  num = 500 - (int)(textView.text.length + textLength) ;
            noteLimitLab.text=[NSString stringWithFormat:@"您还可输入%d个字",num];
        });
        
        return YES;
    }else{
        return NO;
    }
    
    
    return YES;
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

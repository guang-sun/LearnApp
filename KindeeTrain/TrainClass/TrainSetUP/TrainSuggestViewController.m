//
//  TrainSuggestViewController.m
//  KindeeTrain
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 Kindee. All rights reserved.
//

#import "TrainSuggestViewController.h"
#import "TrainCustomTextView.h"
@interface TrainSuggestViewController ()<UITextViewDelegate>
{
    TrainCustomTextView    *suggestTextView;
    UILabel                 *freeindicator;

}
@end

@implementation TrainSuggestViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [suggestTextView becomeFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
    
    self.view.backgroundColor =[UIColor groupTableViewBackgroundColor];

    
    [self creatsuggestView];
    // Do any additional setup after loading the view.
}
-(void)creatsuggestView{
    
    suggestTextView   =[[TrainCustomTextView alloc]init];
    suggestTextView.delegate =self;
    suggestTextView.placeholder = @"写下问题和建议，我们将为您不断改进";
    [self.view addSubview:suggestTextView];
    
    suggestTextView.sd_layout
    .leftSpaceToView(self.view,20)
    .topSpaceToView(self.view,TrainNavorigin_y + 20)
    .rightSpaceToView(self.view,20)
    .heightIs(200);
    
    
    
    freeindicator  =[[UILabel alloc]init];
    freeindicator.textAlignment =NSTextAlignmentRight;
    freeindicator.textColor =[UIColor blackColor];
    freeindicator.text =@"您还有500字可以输入";
    freeindicator.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:freeindicator];
    
    freeindicator.sd_layout.rightEqualToView(suggestTextView).widthIs(300).topSpaceToView(suggestTextView,10).autoHeightRatio(0);
    
    UIButton  *suggestBtn =[[UIButton alloc]initCustomButton];
    suggestBtn.cusTitle = @"提 交";
    suggestBtn.cusTitleColor = [UIColor whiteColor];
    suggestBtn.backgroundColor = TrainNavColor;
    suggestBtn.layer.cornerRadius = 5;
    [suggestBtn addTarget:self action:@selector(suggestfeedback)];
    [self.view addSubview:suggestBtn];
    
    
    suggestBtn.sd_layout
    .leftSpaceToView(self.view,20)
    .topSpaceToView(freeindicator,10)
    .rightSpaceToView(self.view,20)
    .heightIs(40);
    

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [suggestTextView resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > 11) {
        if ([string isEqualToString:@""]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
   
    NSInteger amout=500-textView.text.length;
    freeindicator.text=[NSString stringWithFormat:@"您还有%ld字可以输入",(long)amout];
}

-(void)suggestfeedback{
    
    if(TrainStringIsEmpty(suggestTextView.text)){
        UIAlertController  *alertVC =[UIAlertController alertControllerWithTitle:@"提示" message:@"请，您还没有输入您的意见" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [suggestTextView resignFirstResponder];
        
        [[TrainNetWorkAPIClient client] trainSendOurSuggestWithcontent:suggestTextView.text Success:^(NSDictionary *dic) {
    
            if (dic) {
                if ([dic[@"status"] boolValue]) {
                    [self trainShowHUDOnlyText:@"反馈成功，感谢您的宝贵意见！"];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }

        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
    
            [self trainShowHUDNetWorkError];
            
        }];
        
    }
    
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

//
//  TrainAddNoteViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainAddNoteViewController.h"
#import "TrainCustomTextView.h"
#import "TrainImageButton.h"

@interface TrainAddNoteViewController ()<UITextViewDelegate>
{
    TrainImageButton                *publicNoteBtn;
    TrainCustomTextView             *noteTextView;
    UILabel                         *noteLimitLab;
}
@property(nonatomic, strong) UIButton           *rightBtn;
@end

@implementation TrainAddNoteViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    
    [noteTextView becomeFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString  *navTitle = (!_isEditNote)?@"添加笔记":@"编辑笔记";
    self.navigationItem.title = navTitle;
    
    self.rightBtn =[[UIButton alloc]initCustomButton];
    self.rightBtn.cusTitle = @"提交";
    self.rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    [self.rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.rightBtn.selected = NO;
    self.rightBtn.userInteractionEnabled = NO;
    [self.rightBtn addTarget:self action:@selector(addNote)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];

    
    [self creatNoteView];
    // Do any additional setup after loading the view.
}

-(void)creatNoteView{
    
    UILabel  *titleLab = [[UILabel alloc]creatTitleLabel];
    
    [self.view addSubview:titleLab];
    NSString  *str = @"";
    if (!_isEditNote ) {
        str = @"这是我的新笔记";
    }else{
        str = @"编辑我的笔记";
    }
    titleLab.text = str;

    UIImage  *image = [UIImage imageNamed:@"train_checkbox_on"];
    publicNoteBtn=[[TrainImageButton alloc]initWithFrame:CGRectMake(TrainSCREENWIDTH - 100, TrainNavorigin_y + 5, 90, 30) andImage:image andTitle:@"公开笔记"];
    publicNoteBtn.imageSize = CGSizeMake(15, 15);
    [publicNoteBtn setImage:[UIImage imageThemeColorWithName:@"train_checkbox_off"] forState:UIControlStateSelected];
    [publicNoteBtn addTarget:self action:@selector(updateIspublic:) forControlEvents:UIControlEventTouchUpInside];
    publicNoteBtn.cusFont =13.0f;
    [self.view addSubview:publicNoteBtn];
  
    
    noteTextView=[[TrainCustomTextView alloc]init];
    noteTextView.font=[UIFont systemFontOfSize:16.0f];
    noteTextView.placeholder=@"记录下我的笔记内容";
    noteTextView.delegate = self;
    [noteTextView setAlwaysBounceVertical:YES];
    noteTextView.backgroundColor=[UIColor clearColor];

    TrainWeakSelf(self);
    noteTextView.textViewChangeBlock = ^(NSString *text){
        if (text.length > 0) {
            weakself.rightBtn.selected = YES;
            weakself.rightBtn.userInteractionEnabled = YES;
        }else{
            weakself.rightBtn.selected = NO;
            weakself.rightBtn.userInteractionEnabled = NO;
        }
    };
    [self.view addSubview:noteTextView];
    

    
    noteLimitLab=[[UILabel alloc]creatContentLabel];
    noteLimitLab.text=@"您还可输入500个字";
    noteLimitLab.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:noteLimitLab];
    

    
    titleLab.sd_layout
    .leftSpaceToView(self.view,TrainMarginWidth)
    .topSpaceToView(self.view,TrainNavorigin_y + 10)
    .rightSpaceToView(publicNoteBtn,10)
    .heightIs(20);
    
    noteTextView.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(titleLab,10)
//    .heightIs(50);
    .bottomSpaceToView(self.view,40);
    
    
    
    noteLimitLab.sd_layout
    .rightEqualToView(noteTextView)
    .topSpaceToView(noteTextView,10)
    .widthIs(TrainSCREENWIDTH-20)
    .heightIs(20);

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardFram:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    if (_isEditNote) {
        if ([_editModel.is_public isEqual:@"N"]) {
            publicNoteBtn.selected =NO;
        }else{
            publicNoteBtn.selected =YES;
 
        }
        if ( ![TrainStringUtil trainIsBlankString:_editModel.content ]) {
            noteTextView.text =_editModel.content;
            noteLimitLab.text= [NSString stringWithFormat:@"您还可输入%d个字",500 - (int)(noteTextView.text.length) ];
        }

    }
    
    
    
}

-(void)updateIspublic:(UIButton *)btn{
    btn.selected = !btn.selected;
    
}

-(void)changeKeyboardFram:(NSNotification *)noti{
    NSDictionary  *info =[noti userInfo];
    CGSize  keyHeight =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    TrainWeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        noteTextView.sd_layout
        .bottomSpaceToView(weakself.view,40+keyHeight.height);
        [noteTextView updateLayout];
    }];
    
    
}
-(void)KeyboardHide:(NSNotification *)noti{
    
    TrainWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        
        noteTextView.sd_layout
        .bottomSpaceToView(weakself.view,40);
        [noteTextView updateLayout];

    }];
}

-(void)addNote{
    
    
    
    NSString *mynote=noteTextView.text;
    if ([TrainStringUtil trainIsBlankString:mynote])
    {
        
        [TrainAlertTools showTipAlertViewWith:self title:@"" message:@"笔记内容不能为空！" buttonTitle:@"确定" buttonStyle:TrainAlertActionStyleCancel];
        
        return;
    }
    [noteTextView resignFirstResponder];
    
    [self trainShowHUDOnlyActivity];

    NSMutableDictionary  *muDic = [NSMutableDictionary  dictionary];

    if (_isEditNote) {
        
        if ([noteTextView.text isEqualToString:_editModel.content]) {
            [self trainHideHUD];
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else {
            NSString *ispublicstring=(publicNoteBtn.selected)?@"Y":@"N";
            
            [muDic setObject:notEmptyStr(noteTextView.text) forKey:@"notes.content"];
            [muDic setObject:notEmptyStr(_editModel.note_id) forKey:@"notes.id"];
            [muDic setObject:notEmptyStr(TrainUser.emp_id) forKey:@"notes.last_update_by"];
            [muDic setObject:notEmptyStr(ispublicstring) forKey:@"notes.is_public"];
            
            
        }
    }else{
        
        NSString *ispublicstring=(publicNoteBtn.selected)?@"Y":@"N";

        [muDic setObject:notEmptyStr(noteTextView.text) forKey:@"notes.content"];
        [muDic setObject:notEmptyStr(_infoDic[@"object_id"]) forKey:@"object_id"];
        [muDic setObject:notEmptyStr(_infoDic[@"hour_id"]) forKey:@"notes.hour_id"];
        [muDic setObject:notEmptyStr(ispublicstring) forKey:@"notes.is_public"];
        [muDic setObject:notEmptyStr(_infoDic[@"type"]) forKey:@"type"];
        [muDic setObject:notEmptyStr(_infoDic[@"room_id"]) forKey:@"room_id"];
        [muDic setObject:notEmptyStr(_infoDic[@"c_id"]) forKey:@"notes.c_id"];

//        if ([_infoDic[@"type"] isEqualToString:@"TRAIN"]) {
//            
//            isclass = NO;
//            
//            [muDic setObject:notEmptyStr(noteTextView.text)      forKey:@"content"];
//            [muDic setObject:notEmptyStr(_infoDic[@"object_id"]) forKey:@"object.id"];
//            [muDic setObject:notEmptyStr(_infoDic[@"hour_id"])   forKey:@"hour_id"];
//            [muDic setObject:notEmptyStr(ispublicstring)         forKey:@"is_public"];
//            [muDic setObject:notEmptyStr(@"TRAIN")               forKey:@"type"];
//            
//        }else  if ([_infoDic[@"type"] isEqualToString:@"CLASS"]) {
//            
//            isclass = YES;
//            
//            [muDic setObject:notEmptyStr(noteTextView.text)      forKey:@"notes.content"];
//            [muDic setObject:notEmptyStr(_infoDic[@"room_id"] )  forKey:@"notes.object_id"];
//            [muDic setObject:notEmptyStr(_infoDic[@"c_id"])      forKey:@"notes.c_id"];
//            [muDic setObject:ispublicstring         forKey:@"notes.is_public"];
//            [muDic setObject:@"CLASS"               forKey:@"type"];
//
//        }
    }
    
    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client]trainCourseAddOrEditNoteWithisEditNote:_isEditNote infoDic:muDic Success:^(NSDictionary *dic) {
        
        if (weakself.isEditNote) {
           
            NSMutableDictionary  *muDic =[NSMutableDictionary dictionary];
            [muDic setObject:noteTextView.text forKey:@"content"];
            NSString *ispublicstring=(!publicNoteBtn.selected)?@"Y":@"N";
            [muDic setObject:ispublicstring forKey:@"ispublic"];
            
            if (_updateNoteEditBlock) {
                _updateNoteEditBlock(noteTextView.text);
            }
            
        }else{
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(saveNoteSuccess:)]) {
                [weakself.delegate saveNoteSuccess:dic];
            }
        }
        
        
        NSString  *str = (weakself.isEditNote)?@"修改笔记成功":@"添加笔记成功";
        [weakself trainShowHUDOnlyText: str andoff_y:150.0f];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popViewControllerAnimated:YES];

        });
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

        NSString  *str = (weakself.isEditNote)?@"修改笔记失败,请重试":@"添加笔记失败,请重试";
        [weakself trainShowHUDOnlyText: str andoff_y:150.0f];

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

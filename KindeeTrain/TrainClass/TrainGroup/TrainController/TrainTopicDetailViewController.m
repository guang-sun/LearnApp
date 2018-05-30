//
//  TrainTopicDetailViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainTopicDetailViewController.h"
#import "TrainTopicDetailCommentCell.h"
#import "TrainCustomTextView.h"
#import "TrainTopicListCell.h"

//#import "IMYWebView.h"
#import "TrainTopicDetailHeadView.h"

#import "TrainWebViewController.h"
#import "TrainUserInfoViewController.h"
#define trainwebDefaultHeight   30
@interface TrainTopicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIWebViewDelegate>
{
  

//    TrainBaseTableView      *commentTableView;
    
    
    float                   headHeight;
    //底部发话题
    UIView                  *commentBgView;
    TrainCustomTextView     *commentTextView;
    UIButton                *sendBtn;
    
    
    
    UIButton            *addPhotoBtn;
    NSMutableArray      *commentListMuArr;
    
    float               keyboardHeight;
    
    
    TrainTopicCommentModel      *commentInfo;
    NSIndexPath                 *selectIndex;
    NSString                    *huiFuName;
    
    
    BOOL                        isMember;
    NSInteger                   pv_flag;
    NSString                    *group_id;
}

@property(nonatomic,strong) TrainTopicDetailHeadView    *headview;
@property(nonatomic,strong) TrainTopicModel             *topicModel;
@property(nonatomic,strong) TrainBaseTableView          *commentTableView;

@end

@implementation TrainTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _model.gg_title ;
    
    headHeight      = 0;
    isMember        = NO;
    pv_flag         = -1;
    group_id        = @"";

    [self creatCommentTableView];
    [self creatDownView];

     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
     // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    if (_updateModel) {
        
        self.topicModel.content = _model.content;
        _updateModel(self.topicModel);
    }
}

-(void)addRemoveRightBtn{
    
    UIButton *removeBtn = [[UIButton alloc]initCustomButton];
    
    removeBtn.image = [UIImage imageSizeWithName:@"Train_Topic_Delete"];
    removeBtn.frame = CGRectMake( TrainSCREENWIDTH - 40, 0, 30, 44);
    [removeBtn addTarget:self action:@selector(removeThisTopic)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:removeBtn];
}

-(void)removeThisTopic{
    
    TrainWeakSelf(self);
    [TrainAlertTools showAlertWith:self title:@"删除该话题" message:nil callbackBlock:^(NSInteger btnIndex) {
     
        if (btnIndex == 1) {
            
            [weakself trainShowHUDOnlyActivity];
            
            NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
            [mudic setObject:group_id forKey:@"object_id"];
            [mudic setObject:self.topicModel.topic_id forKey:@"id"];
            NSArray  *arr = @[mudic];
            
            NSString *strObj = [arr mj_JSONString];
            
            [[TrainNetWorkAPIClient client] trainRemoveTopicWithtopicInfo:strObj Success:^(NSDictionary *dic) {
                
                NSString *str = @"";
                if ([dic[@"success"] isEqualToString:@"S"]) {
                    weakself.topicModel = nil;
                    str = @"删除成功";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakself.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    str = dic[@"msg"];
                }
                [weakself trainShowHUDOnlyText:str];

            } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                [weakself trainShowHUDNetWorkError];
                
            }];
        }
        
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
  
    
    
}

-(void)downloadTopicData:(int)index{
    
    [self trainShowHUDOnlyActivity];
    
    TrainWeakSelf(self);

    [[TrainNetWorkAPIClient client] trainTopicDetailInfoWithTopic_id:self.model.topic_id group_id:self.model.object_id curPage:index Success:^(NSDictionary *dic) {
        
        if (index ==1) {
            commentListMuArr =[NSMutableArray new];
            
        }
        /*
        pv_flag =-1 非小组成员
        pv_flag =1 组长
        pv_flag =2 副组长
        pv_flag =0 小组成员
        */
        group_id   = [dic[@"topic"][@"object_id"] stringValue];

        weakself.topicModel =[TrainTopicModel mj_objectWithKeyValues:dic[@"topic"]];
        weakself.topicModel.gg_title = _model.gg_title;
        weakself.topicModel.type     = _model.type;
        weakself.topicModel.totPage  = _model.totPage;
        
        
        if([weakself.topicModel.object_type isEqualToString:@"GROUP"]){
            pv_flag = (dic[@"pv_flag"]) ? [dic[@"pv_flag"] integerValue] : -1;
 
        }else{
            pv_flag = 0;
        }
        
        NSArray  *dataArr =[TrainTopicCommentModel mj_objectArrayWithKeyValuesArray:dic[@"post"]];
        
        if (pv_flag != -1 ) {
            if (pv_flag == 1 ||  [weakself.topicModel.user_id isEqualToString:TrainUser.user_id] ) {
                [weakself addRemoveRightBtn];
            }
            isMember = YES;
        }else {
            isMember = NO;
        }
        [weakself updateDownViewStatus];
        
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TrainTopicCommentModel *postModel= obj;
            if (!TrainArrayIsEmpty(postModel.child_post_list)) {
                NSArray  *dataArr1 =[TrainTopicCommentModel mj_objectArrayWithKeyValuesArray:postModel.child_post_list];
                postModel.child_post_list = dataArr1;
            }
        }];
        
        [commentListMuArr addObjectsFromArray:dataArr];
        
        
        [weakself.headview updateViewHeightWith:weakself.topicModel andGetHeight:^(CGFloat height) {
            
            weakself.headview.frame =CGRectMake(0, 0, TrainSCREENWIDTH, height);
            weakself.commentTableView.tableHeaderView = weakself.headview;
            [weakself.commentTableView reloadData];
        }];
        
        if (commentListMuArr.count>0) {
            TrainTopicCommentModel *model =[commentListMuArr objectAtIndex:0];
            weakself.commentTableView.totalpages =[model.totPage intValue];
        }
        [weakself.commentTableView reloadData];
        [weakself.commentTableView EndRefresh];
        
        [weakself trainHideHUD];
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [weakself trainShowHUDNetWorkError];
        [weakself.commentTableView reloadData];
        [weakself.commentTableView EndRefresh];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    
}
-(void)topiciconTouch{
    [self pushUserInfoVC:_model.user_id];
}

-(void)pushUserInfoVC:(NSString *)user_id{
    TrainUserInfoViewController  *userInfoVC =[[TrainUserInfoViewController alloc]init];
    userInfoVC.user_id = user_id;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

-(void)creatDownView{
    
    commentBgView = [[UIView alloc]init];
    commentBgView.userInteractionEnabled =YES;
    commentBgView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:commentBgView];
    
    commentBgView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0)
    .heightIs(50);
    
    commentTextView = [[TrainCustomTextView alloc]init];
    commentTextView.font = [UIFont systemFontOfSize:14.0f];
    commentTextView.isAutolayoutHeight = YES;
    commentTextView.maxNumberOfLines = 4;
    commentTextView.placeholder = @"评论";
    commentTextView.placeholderColor = TrainContentColor;
    commentTextView.backgroundColor = [UIColor whiteColor];
    [commentBgView addSubview:commentTextView];
    
    __weak  typeof(commentBgView)weakView = commentBgView;
    commentTextView.trainTextHeightChangeBlock =^(CGFloat height){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakView.sd_layout.heightIs(height+20);
            [weakView updateLayout];
        }];
        
    };
    
    sendBtn = [[UIButton alloc]initCustomButton];
    sendBtn.layer.cornerRadius = 3.0f;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:TrainNavColor];
    [sendBtn addTarget:self action:@selector(sendComment:)];
    [commentBgView addSubview:sendBtn];
    
    sendBtn.sd_layout
    .rightSpaceToView(commentBgView,TrainMarginWidth)
    .bottomSpaceToView(commentBgView,10)
    .widthIs(50)
    .heightIs(30);
    
    commentTextView.sd_layout
    .leftSpaceToView(commentBgView,TrainMarginWidth)
    .rightSpaceToView(sendBtn,10)
    .topSpaceToView(commentBgView,10)
    .bottomSpaceToView(commentBgView,10);
    
    [self registeNotifications];
    
}
-(void)updateDownViewStatus{
    if (isMember) {
        
        [sendBtn setBackgroundColor:TrainNavColor];
    }else{
        
        [sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        UIButton  *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 50)];
        [button addTarget:self action:@selector(showNotMember)];
        [commentBgView addSubview:button];
    }
}


-(void)registeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKeyboardFram:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeNotifications{
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [TrainNotiCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)changeKeyboardFram:(NSNotification *)noti{

    NSDictionary  *info =[noti userInfo];
    CGSize  keyHeight =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        commentBgView.sd_layout.bottomSpaceToView(self.view ,keyHeight.height);
        [commentBgView updateLayout];
        
    }];
    
}
-(void)KeyboardHide:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        commentBgView.sd_layout.bottomSpaceToView(self.view , 0);
        [commentBgView updateLayout];
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [commentTextView resignFirstResponder];
}


-(void)resetCommentView{
    
    if (commentBgView.height >50) {
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.sd_layout.heightIs(50);
            [commentBgView updateLayout];
            
        }];
        
    }
   
    commentInfo = nil;
    selectIndex =nil;
    huiFuName=nil;
    commentTextView.text = @"";
    commentTextView.placeholder = @"评论";
    [commentTextView resignFirstResponder];
    
}
#pragma  mark -回复

-(void)showNotMember{
    
    [self trainShowHUDOnlyText:TrainNotJoinText];
    
}

-(void)sendComment:(UIButton *)btn
{
    
    if (!isMember) {
        [self showNotMember];
        return;
    }
    
    if ([TrainStringUtil trainIsBlankString:commentTextView.text]) {
        [self trainShowHUDOnlyText:@"输入为空"];
        return;
    }
    [self trainShowHUDOnlyActivity];
    
    NSString *sendStr  = commentTextView.text;
    NSMutableDictionary *mudic = [NSMutableDictionary dictionary];
    
    if (commentInfo) {
        
        if (huiFuName) {
            sendStr =[NSString  stringWithFormat:@"回复 %@:%@",huiFuName,commentTextView.text];
        }
        [mudic setObject:sendStr forKey:@"content"];
        [mudic setObject:notEmptyStr(commentInfo.topic_id)   forKey:@"topic_id"];
        [mudic setObject:notEmptyStr(commentInfo.user_id)    forKey:@"from_user_id"];
        [mudic setObject:notEmptyStr(commentInfo.comment_id) forKey:@"from_post_id"];
    }else{
        [mudic setObject:sendStr forKey:@"content"];
        [mudic setObject:notEmptyStr(_model.topic_id) forKey:@"topic_id"];
        [mudic setObject:@"0" forKey:@"from_user_id"];
        [mudic setObject:@"0" forKey:@"from_post_id"];
    }
    
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainPostTopicWithinfoDic:mudic postType:NO Success:^(NSDictionary *dic) {
        
        if ([dic[@"msg"] isEqualToString:@"true"]) {
            if (commentInfo) {
                
                TrainTopicCommentModel  *post = commentListMuArr[selectIndex.row];
                post.child_post_list = [TrainTopicCommentModel mj_objectArrayWithKeyValuesArray:dic[@"child_post_list"]];
                [weakself.commentTableView reloadRowsAtIndexPaths:@[selectIndex] withRowAnimation:UITableViewRowAnimationNone];
                
            }else{
                
                weakself.commentTableView.currentpage = 1;
                [weakself downloadTopicData:1];
               
                
            }
            [weakself resetCommentView];
            
        }else{
            
            [weakself trainShowHUDOnlyText:@"话题回复失败,请重试"];
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
        [weakself trainShowHUDNetWorkError];
    }];
    
}



-(void)creatCommentTableView{
    
    self.commentTableView = [[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT- TrainNavHeight -50) andTableStatus:tableViewRefreshAll];
    self.commentTableView.delegate =self;
    self.commentTableView.dataSource =self;
    self.commentTableView.tag =2;
    [self.commentTableView registerClass:[TrainTopicDetailCommentCell class] forCellReuseIdentifier:@"commentCell"];
    
    [self.view addSubview:self.commentTableView];
    
    TrainWeakSelf(self);
    
    self.commentTableView.footBlock =^(int  index){
        [weakself downloadTopicData:index];
    };
    self.commentTableView.headBlock =^(){
        [weakself downloadTopicData:1];
    };

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (commentListMuArr) ? commentListMuArr.count : 0 ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainTopicDetailCommentCell *commentCell =[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    TrainTopicCommentModel  *model =commentListMuArr[indexPath.row];
    commentCell.index = indexPath.row;
    commentCell.model =model;
    
    TrainWeakSelf(self);
    commentCell.topicLine =^(TrainTopicCommentModel *mod, NSString *userName, NSInteger index){

        if ([mod.user_id isEqualToString:TrainUser.user_id] ) {
            
            commentInfo     = mod;
            selectIndex     = indexPath;
            huiFuName       = userName;
            
            [weakself removeOnlyTopicPostWith:mod andRemoveIndex:index];
            
        }else{
            BOOL  qqq = [commentInfo isEqual:mod];
            if (commentInfo && qqq ) {
                [weakself resetCommentView];
                
            }else{
                commentInfo     = mod;
                selectIndex     = indexPath;
                huiFuName       = userName;
                [weakself commentHuiFu];
            }
        }
    };
    commentCell.topicName =^(NSString *user_id){
        NSLog(@"%@",user_id);
        [weakself pushUserInfoVC:user_id];
    };
    
    commentCell.topicRemove = ^(NSInteger  postIndex, NSString *str){
        if ([str isEqualToString:@"删除成功"]) {
           
            [weakself dealCommentRemoveWithSelectIndex:postIndex andFirstIndex:indexPath.row];
        }
        
        [weakself trainShowHUDOnlyText:str];

    };
    
    return commentCell;
    
    
}


-(void)removeOnlyTopicPostWith:(TrainTopicCommentModel *)model andRemoveIndex:(NSInteger)removeIndex{
    
    TrainWeakSelf(self);
    [TrainAlertTools showActionSheetWith:self title:model.full_name message:model.content callbackBlock:^(NSInteger btnIndex) {
        
        if(btnIndex == 0){
            [weakself trainShowHUDOnlyActivity];
            
            [[TrainNetWorkAPIClient client] trainRemoveTopicPostWithTopic_id:model.topic_id post_id:model.comment_id Success:^(NSDictionary *dic) {
                    
                    NSString  *str = @"";
                    if ([dic[@"success"] isEqualToString:@"S"]) {
                        str = @"删除成功";
                        [weakself dealCommentRemoveWithSelectIndex:removeIndex andFirstIndex:selectIndex.row];
                        
                    }else{
                        str = dic[@"msg"];
                    }
                    [weakself resetCommentView];
                    [weakself trainShowHUDOnlyText:str];
                    
                } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                    [weakself trainShowHUDNetWorkError];
                    [weakself resetCommentView];

                }];
                
           
            
        }else if(btnIndex ==2){
            
            [weakself commentHuiFu];
            
        }else{
            if ( TrainStringIsEmpty(commentTextView.text)) {
                [weakself resetCommentView];
            }else{
                [commentTextView resignFirstResponder];
            }

        }
        
    } destructiveButtonTitle:@"删除" cancelButtonTitle:@"取消" otherButtonTitles:@"回复", nil];
}



-(void)dealCommentRemoveWithSelectIndex:(NSInteger)postIndex andFirstIndex:(NSInteger)firstIndex{
    
    if (postIndex == -1) {

        [commentListMuArr removeObjectAtIndex:firstIndex];
        [commentListMuArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TrainTopicCommentModel  *model = obj;
            model.totCount = [NSString stringWithFormat:@"%zi",[model.totCount integerValue] -1];
        }];
        [self.commentTableView reloadData];
        
    }else{
        TrainTopicCommentModel  *model = commentListMuArr[firstIndex];
        NSMutableArray  *muArr = [NSMutableArray arrayWithArray:model.child_post_list];
        if (postIndex < muArr.count) {
            [muArr removeObjectAtIndex:postIndex];
        }
        model.child_post_list = muArr;
        
        [self.commentTableView reloadData];
    }
    
   

}

-(void)commentHuiFu{
    
    
    
    [commentTextView becomeFirstResponder];
    NSString  *placeholderStr;
    if (huiFuName) {
        placeholderStr =[NSString  stringWithFormat:@"@%@",huiFuName];
    }else{
        placeholderStr =[NSString  stringWithFormat:@"@%@",commentInfo.full_name];
    }
    commentTextView.placeholder =placeholderStr;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:TrainSCREENWIDTH tableView:tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [commentTextView resignFirstResponder];
    
    TrainTopicCommentModel *mod = commentListMuArr[indexPath.row];
    
    if ([mod.user_id isEqualToString:TrainUser.user_id] ) {
        
        commentInfo     = mod;
        selectIndex     = indexPath;
        huiFuName       = mod.username;
        
        [self removeOnlyTopicPostWith:mod andRemoveIndex: -1];
        
    }else{
        
        BOOL  qqq = [commentInfo isEqual:mod];
        if (commentInfo && qqq ) {
            [self resetCommentView];
            
        }else{
            commentInfo     = mod;
            selectIndex     = indexPath;
            huiFuName       = mod.username;
            [self commentHuiFu];
        }
    }

    
    
}


-(TrainTopicDetailHeadView *)headview{
    if (!_headview) {
        
        TrainTopicDetailHeadView *hhh = [[TrainTopicDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, TrainSCREENWIDTH, 100)];
        
        TrainWeakSelf(self);
        hhh.topicIconTouchBlock = ^(NSString  *user_id){
            [weakself pushUserInfoVC:user_id];

        };
        
        hhh.topicTopandCollectBlock =^(NSString *str, TrainTopicModel *topicModel){
            
            if (topicModel) {
                weakself.topicModel = topicModel;
            }
            
            [weakself trainShowHUDOnlyText:str];
        };
        hhh.topicContentTouchBlock =^(NSString *url){
            
            [weakself gotoWebView:url];
        };

        _headview = hhh;
    }
    return _headview;
}
-(void)gotoWebView:(NSString  *)webURL{
    
    TrainWebViewController *webVC =[[TrainWebViewController alloc]init];
    webVC.webURL =webURL;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];

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

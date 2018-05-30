//
//  TrainMyNoteViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainMyNoteViewController.h"
#import "TrainAddNoteViewController.h"
#import "TrainMyNoteModel.h"
#import "TrainMyNoteCell.h"

@interface TrainMyNoteViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray                  *noteMuarr;
    
}
@property( nonatomic, strong) TrainBaseTableView              *myNoteTableView;


@end

@implementation TrainMyNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的笔记";
    
    self.myNoteTableView =[[TrainBaseTableView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainSCREENHEIGHT - TrainNavHeight) andTableStatus:tableViewRefreshAll];
    [self.view addSubview:self.myNoteTableView];
    self.myNoteTableView.delegate =self;
    self.myNoteTableView.dataSource =self;
    [self.myNoteTableView registerClass:[TrainMyNoteCell class] forCellReuseIdentifier:@"cell"];
    
    [self downLoadNewsData:1];

    TrainWeakSelf(self);
    self.myNoteTableView.headBlock =^(){
      
        [weakself downLoadNewsData:1];
    };
    self.myNoteTableView.footBlock=^(int  aa){
       
        [weakself downLoadNewsData:aa];
    };
    self.myNoteTableView.refreshBlock =^(){

        [weakself downLoadNewsData:1];
        
    };
  
    // Do any additional setup after loading the view.
}

#pragma  mark - download数据
-(void)downLoadNewsData:(int )index{
    
    [self trainShowHUDOnlyActivity];
    [self.myNoteTableView dissTablePlace];
   
    TrainWeakSelf(self);
    
    [[TrainNetWorkAPIClient client] trainMyNoteWithcurPage:index Success:^(NSDictionary *dic) {
        if (index == 1) {
            noteMuarr =[NSMutableArray new];
        }
        NSArray  *dataArr = [TrainMyNoteModel  mj_objectArrayWithKeyValuesArray:dic[@"note"]];
        [noteMuarr addObjectsFromArray:dataArr];
        if (noteMuarr.count>0) {
            TrainMyNoteModel *model =[noteMuarr firstObject];
            weakself.myNoteTableView.totalpages =[model.totPage intValue];
        }
        
       weakself. myNoteTableView.trainMode = trainStyleNoData;
        [weakself. myNoteTableView EndRefresh];
        [weakself trainHideHUD];
        
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {

        weakself. myNoteTableView.trainMode = trainStyleNoNet;
        [weakself. myNoteTableView EndRefresh];
        [weakself trainShowHUDNetWorkError];
    }];
    
   }
#pragma  mark  - tableview的代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return cellStatusArr.count;
    return noteMuarr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrainMyNoteCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    TrainMyNoteModel *model =noteMuarr[indexPath.row];
    cell.model = model;
    cell.unfoldBlock =^(){
        model.isOpen =!model.isOpen;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    TrainWeakSelf(self);
    cell.editDeleteBlock =^(NSInteger  index){
        if (index ==2) {
            [weakself deleteNote:indexPath];
        }else{
            [weakself editNote:indexPath];
            
        }
    };
    
    return cell;
}

#pragma mark  - 编辑
-(void)editNote:(NSIndexPath *)index{
    TrainMyNoteModel *model =noteMuarr[index.row];
    
    TrainAddNoteViewController  *noteVC =[[TrainAddNoteViewController alloc]init];
    noteVC.isEditNote = YES;
    noteVC.editModel = model;
    TrainWeakSelf(self);
    noteVC.updateNoteEditBlock =^(NSString *content){
       
        model.content =content;
        [weakself.myNoteTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:noteVC animated:YES];
}


#pragma mark  - 删除
-(void)deleteNote:(NSIndexPath *)index{
    
    TrainMyNoteModel *model =noteMuarr[index.row];
    TrainWeakSelf(self);
    
    
    [TrainAlertTools showAlertWith:self title:@"提示" message:TrainMyNoteDeleteText callbackBlock:^(NSInteger btnIndex) {
        
        if(btnIndex ==1){
            [weakself trainShowHUDOnlyActivity];
            
            [[TrainNetWorkAPIClient client] trainDeleteMyNoteWithNote_id:model.note_id Success:^(NSDictionary *dic) {
                if ([dic[@"status"] boolValue]) {

                    [noteMuarr removeObject:model];
                    [weakself.myNoteTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationLeft];
                    [weakself.myNoteTableView train_reloadData];
                    [weakself  trainShowHUDOnlyText:TrainDeleteSuccess];
                    
                }else{
                    [weakself  trainShowHUDOnlyText:TrainDeleteFail];
                    
                }
                
            } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                [weakself trainShowHUDNetWorkError];
            }];
 
        }
        
    } cancelButtonTitle:@"否" destructiveButtonTitle:@"是" otherButtonTitles:nil, nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.myNoteTableView cellHeightForIndexPath:indexPath model:noteMuarr[indexPath.row] keyPath:@"model" cellClass:[TrainMyNoteCell class] contentViewWidth:TrainSCREENWIDTH];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

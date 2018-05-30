//
//  TrainNewsDetailViewController.m
//  KindeeTrain
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 Kindee. All rights reserved.
//

#import "TrainNewsDetailViewController.h"

@interface TrainNewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@end

@implementation TrainNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.newsModel.title ;
//    
//    self.descLabel.text = self.newsModel.content ;
//    self.dataLabel.text = self.newsModel.send_time ;

    TrainWeakSelf(self);
    [[TrainNetWorkAPIClient client] trainGetNewsDetailWithid:self.newsModel.news_id Success:^(NSDictionary *dic) {
        
        NSDictionary  *newsDic = dic[@"message"];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[newsDic[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        weakself.descLabel.attributedText = attrStr;
        weakself.dataLabel.text = newsDic[@"send_time"] ;
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
    
    if (!self.readStatus) {
        
        [[TrainNetWorkAPIClient client] trainReadNewsWithisid:self.newsModel.news_id Success:^(NSDictionary *dic) {
            
        } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
            
        }];
    }
    
   
    
    // Do any additional setup after loading the view from its nib.
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

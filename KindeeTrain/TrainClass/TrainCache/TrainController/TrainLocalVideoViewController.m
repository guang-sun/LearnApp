//
//  TrainLocalVideoViewController.m
//  SOHUEhr
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 com.sohu-inc. All rights reserved.
//

#import "TrainLocalVideoViewController.h"
#import "TrainPlayerView.h"
#import "TrainDownloadManager.h"
@interface TrainLocalVideoViewController ()<TrainPlayerDelegate>
{
    UIView  *movieBgView;
    __block NSDate    *startDate;
    __block  NSInteger  _learnZongTime;
    __block  NSInteger  _pauseTime;
    BOOL  isNotBack ;
}
@property (strong,nonatomic) TrainPlayerView         *playerController;
@property (nonatomic,strong) TrainPlayerModel        *playerModel;

@end

@implementation TrainLocalVideoViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatPlayerView];
    [self play];
    isNotBack = NO ;

    // Do any additional setup after loading the view.
}



-(void)creatPlayerView{
    
    if (movieBgView) {
        return;
    }
    movieBgView = [[UIView alloc]initWithFrame:CGRectMake(0, TrainNavorigin_y, TrainSCREENWIDTH, TrainMovieHeight)];
    [self.view addSubview:movieBgView];
    self.playerModel.fatherView = movieBgView;
    
    TrainPlayerControlView *controlView = [[TrainPlayerControlView alloc] init];
    controlView.islocalMovie = YES;
    [self.playerController playerControlView:controlView playerModel:self.playerModel];
    
}
-(TrainPlayerView *)playerController{
    
    if (_playerController == nil) {
        
        TrainPlayerView  * playerViewC = [[TrainPlayerView alloc] init];
        // 设置代理
        playerViewC.delegate = self;
        // 打开预览图
        playerViewC.hasPreviewView = NO;
        // 是否自动播放，默认不自动播放
        [playerViewC autoPlayTheVideo];
    
        _playerController  = playerViewC;
        
    }
    return _playerController;
}
-(void)dealloc{
    TrainNSLog(@"trainmoviewVIew dealloc =111==>>");

}

-(TrainPlayerModel *)playerModel{
    if (!_playerModel ) {
        TrainPlayerModel      *newplayModel = [[TrainPlayerModel alloc]init];
        newplayModel.placeholderImage = [UIImage imageWithColor:[UIColor blackColor]];
        newplayModel.isLocked = YES;
        
        _playerModel  = newplayModel;
    }
    return _playerModel;
}

-(void)play{
    
    
    if (self.videoModel.last_time >= 1) {
        self.playerModel.seekTime = self.videoModel.last_time ;
    }else{
        self.playerModel.seekTime = 0;
        
    }
    self.playerModel.title       = self.videoModel.courseName;
    self.playerModel.isFinish    = self.isfinishVideo;
    
    NSString  *localMovieURL = [NSString stringWithFormat:@"%@/%@",learnCachesDirectory,self.videoModel.saveFileName];
    
    self.playerModel.videoURL = [NSURL  fileURLWithPath:localMovieURL];
    
    [self.playerController resetToPlayNewVideo:self.playerModel];

}
-(void)Train_playerNotPan{
    
    //    [self trainShowHUDOnlyText:TrainMovieNoFinishText andoff_y:150.f];
    //    +(void)showMessage:(NSString *)msg inView:(UIView *)view;
    
    [TrainProgressHUD showMessage:TrainMovieNoFinishText inView:movieBgView];
}

- (void)Train_playerStartPlay {
    startDate = [NSDate date];
    
}

- (void)Train_playerStopPauseTime:(NSInteger)pauseTime {
    _pauseTime = pauseTime;
    
}


-(void)Train_playerBackAction:(NSInteger)lastTime{
    if (isNotBack) {
        isNotBack = NO ;
        return ;
    }
    if( lastTime > 3 && self.videoModel.last_time >= 0 ){
        self.videoModel.last_time = lastTime - 1;
    }else{
        self.videoModel.last_time = 0;
    }
    [self.videoModel updateObjectsByColumnName:@[@"CHO_id"]];
    [self updateLocalRecodeWithStatus:NO];
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)Train_playerFinish:(NSInteger)lastTime{
    isNotBack = YES ;
    
    self.videoModel.last_time = 0;
    [self.videoModel updateObjectsByColumnName:@[@"CHO_id"]];
    [self trainShowHUDOnlyText:@"已播放完成,退出"];
    [self updateLocalRecodeWithStatus:YES];
    [self.playerController stopPlayer];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)updateLocalRecodeWithStatus:(BOOL )Status {
    NSString  *CriteriaStr = [NSString stringWithFormat:@"c_id = %@ and lh_id = %@",self.videoModel.c_id, self.videoModel.hour_id];
    TrainLocalLearnRecord *record =  [TrainLocalLearnRecord findFirstByCriteria:CriteriaStr];
    NSArray  *arr = [TrainLocalLearnRecord findAll ];
    
    NSInteger  studyTime = 0;
    _learnZongTime = ABS([startDate timeIntervalSinceNow]);
    
    if (_learnZongTime > _pauseTime) {
        studyTime = _learnZongTime - _pauseTime;
    }
    startDate = nil;
    if (record ) {
        record.last_time = self.videoModel.last_time ;
        record.time += studyTime ;
        
    }else {
        
        record = [[TrainLocalLearnRecord alloc]init];
        record.c_id = self.videoModel.c_id;
        record.cw_id = self.videoModel.object_id ;
        record.go_num = 0;
        record.last_time = self.videoModel.last_time ;
        record.lh_id = self.videoModel.hour_id;
        record.object_id = (TrainStringIsEmpty(self.object_id))? @"0" : self.object_id ;
        record.time = studyTime ;
        record.user_id = TrainUser.user_id ;
    }
    if (_trainSaveLocalBlock) {
        _trainSaveLocalBlock(Status , record);
    }
    // [record saveOrUpdateByColumnName:@[@"c_id",@"lh_id"]];
    
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

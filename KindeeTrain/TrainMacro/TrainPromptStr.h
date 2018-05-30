//
//  TrainPromptStr.h
//  SOHUEhr
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年  . All rights reserved.
//

#ifndef TrainPromptStr_h
#define TrainPromptStr_h


#pragma mark - userDefault key

#define TrainWelComeAD          @"TRAINWELCOMEAD"   // 广告也
#define TrainLoginRemember      @"TRAINREMEMBER"    //
#define TrainSearchHistory      @"TRAINSEARCHHISTORY"  //搜索历史
#define TrainLoginErrorPass     @"TRAINPASSDATE"       // 3次输入错误密码后记录解锁时间

#define TrainCollectionVersion  @"TRAINCOLLECTIONVERSION10"  //首页九宫格 //10 修改
#define TrainHomeLocalArr       @"TRAINHOMELOCALARR10"        //10 修改
#define TrainAllowWWANPlayer    @"TRAINCELLULAR"          // 流量看视频 非WIFI 视频可以播放/下载

#define TrainAllowRe            @"TrainAllowReto" 

//#define SetUpDownload  @"SETUP"              //

//上拉下拉刷新
#define TrainFootNoDataText     @"没有更多了"
#define TrainHeaderPullText     @"下拉刷新"
#define TrainHeaderReleaseText  @"松开后刷新"
#define TrainRefreshingText     @"刷新中..."
#define TrainFooterPullText     @"上拉加载更多"
#define TrainFooterReleaseText  @"松开加载更多"
#define TrainLoadingText        @"加载中..."


//tableview  无数据 无网络
#define TrainNoDataText         @"暂无数据~"
#define TrainNoNetWorkText      @"网络不太顺畅喔~"
// hud
#define TrainNetWorkError       @"网络无效，请检查您的网络配置"
#define TrainSiteIPNullText     @"网校域名不正确"
#define TrainLoginMoreErrorText @"您已输错3次密码，请稍后再试"

//首页 searchbar
#define TrainSearchTitleText    @"课程、话题、文档"
//首页 collectionView
#define TrainHomeMore           @"功能尚未开通,尽请期待"

#define TrainSearchNullText     @"请输入搜索的关键字"

//扫一扫
#define TrainScanPermissionText @"请在iOS\"设置\"－\"隐私\"－\"相机\"中开启摄像头使用授权"
#define TrainNotCameraText      @"未获得授权使用摄像头"

// 我的笔记
#define TrainMyNoteDeleteText   @"是否删除当前笔记"

#define TrainDeleteSuccess      @"删除成功"
#define TrainDeleteFail         @"删除失败,请重试"


#define TrainNotJoinText         @"请先加入圈子,才能发表话题"

#define TrainJoinGroupText       @"成功加入圈子"

#define TrainUploadingText       @"图片上传中,请等待"
#define TrainUploadSuccessText   @"上传图片成功"
#define TrainUploadFailText      @"上传图片失败"

#define TrainCommentText         @"发表您的讨论"

#define TrainHourNotSupportText  @"抱歉，此课时暂不支持移动端播放，请到PC端观看。"
#define TrainWWANPlayerText      @"使用移动网络观看或下载视频会消耗较多流量"
#define TrainMovieNoFinishText   @"课时未学完，不能调整进度"
#define TrainOrderToPlayText     @"此课程要求按课时顺序完成学习，请先完成上一课时后再学习此课时！"
//#define TrainWWANPlayerText      @"是否允许"

#define TrainNULLText            @"暂无"
#define TrainNULLdescribeText    @"暂无说明"


#endif /* TrainPromptStr_h */

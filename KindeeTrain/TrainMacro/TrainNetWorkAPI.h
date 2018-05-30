//
//  TrainNetWorkingAPI.h
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#ifndef TrainNetWorkAPI_h
#define TrainNetWorkAPI_h

#import "TrainUserInfo.h"
#import "TrainNetWorkConfiguration.h"
#import "TrainNetWorkAPIEngine.h"

//#if PROJECTMODEDEV == 1
//
//
//#else
//
//#endif




#ifdef DEBUG

//#define TrainWelcomeURL   @"https://101.201.48.193"
#define TrainWelcomeURL  TrainUser.site // @"https://101.201.48.193"

#define TrainIP           TrainUser.site
//#define TrainIP    @"https://101.201.48.193"
//#define TrainIP    @"http://10.42.0.72:8080"
//#define TrainIP    @"http://192.168.11.127:8080"


#else
#define TrainWelcomeURL  TrainUser.site // @"https://101.201.48.193"
#define TrainIP           TrainUser.site


#endif



#endif /* TrainNetWorkAPI_h */

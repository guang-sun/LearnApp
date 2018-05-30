//
//  TrainStringUtil.m
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainStringUtil.h"
#import "TrainMacroDefine.h"
#import <CommonCrypto/CommonDigest.h>

#import <sys/types.h>
#import <sys/sysctl.h>

@implementation TrainStringUtil


CGFloat trainAutoLoyoutImageSize(CGFloat size){
    
    NSString *deviceName = [TrainStringUtil getCurrentDeviceModel];
    if (deviceName) {
        
        if ([deviceName rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([deviceName rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceName rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    CGFloat   newSize = size;
    if ([deviceName isEqualToString:@"iPad"]) {
        
//        newSize = size * 2;
    }else{
        
    }

    return newSize;
}
CGFloat trainAutoLoyoutTitleSize(CGFloat size){
    
    NSString *deviceName = [TrainStringUtil getCurrentDeviceModel];
    if (deviceName) {
        
        if ([deviceName rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([deviceName rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([deviceName rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
    }
    
    CGFloat   newSize = size;
    if ([deviceName isEqualToString:@"iPad"]) {
        
//        newSize = size + 5 ;
    }else{
        
    }
    
    return newSize;
}




NSString  *notEmptyStr(NSString  *str)
{
    
    NSString *string = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (TrainStringIsEmpty(string)) {
        return @"";
    }
    return string;
}

bool comparisonStr(NSString *str1 , NSString *str2){
    
    return [str1 isEqualToString:str1];
    
}

+ (BOOL)trainIsBlankString:(NSString *)string
{
    if (!string)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

//获取字符串的尺寸
+ (CGSize)trainGetStringSize:(NSString *)namestr andMaxSize:(CGSize)maxSize AndLabelFountSize:(CGFloat)fontSize{
    //存放label字体大小的字典，此处的font大小要与label保持一致
    //设置换行条件，可以理解为固定格式
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//输入的字体的大小
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    //利用boundingRectWithSize方法获取字符串的尺寸
    CGSize labelSzie = [namestr boundingRectWithSize:maxSize options:options attributes:dic context:nil].size;
    //    NSLog(@"***------%f",labelSzie.width);
    if (labelSzie.width < maxSize.width)
    {
        return CGSizeMake(maxSize.width, labelSzie.height);
    }
    return labelSzie;
}

+ (NSDictionary *)trainDicWithData:(NSData *)data
{
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) ;
    NSString *dataString = [[NSString alloc]initWithData:data  encoding:enc ];
    
    NSData  *dad =[dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: dad
                                                        options:NSJSONReadingMutableLeaves
                                                          error:nil];
    return dic;
};

+ (NSString *)trainReplaceHtmlCharacter:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html=[html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
}

+ (NSString*)trainURLEscapes:(NSString *)urlparameter
{
    
        NSString * encodedString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, CFBridgingRetain([NSString stringWithFormat:@"%@",urlparameter]), NULL, (CFTypeRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        return encodedString;
}


+ (NSString *)trainConstellationFromDate:(NSString *)date
{
    
    //  @"2015-10-10"
    int day =[[date substringFromIndex:8] intValue];
    
    NSRange   range ={5,2};
    int  month =[[date substringWithRange:range] intValue];
    
    NSArray *constellationArr =@[@"(摩羯座)",@"(水瓶座)", @"(双鱼座)", @"(白羊座)", @"(金牛座)",@"(双子座)", @"(巨蟹座)", @"(狮子座)", @"(处女座)",@"(天秤座)", @"(天蝎座)", @"(射手座)", @"(摩羯座)"];
    NSArray  * dayArr=@[@"20",@"19",@"21",@"21",@"21",@"22",@"23",@"23",@"23",@"23",@"22",@"22"];
    
    int a =month*2-(day < [[dayArr objectAtIndex:month-1] intValue]?2:0);
    
    return [constellationArr objectAtIndex:a/2];
    
}

+ (NSString *)trainLongTimeBetweenNowWithDate:(NSString *)date
{
    NSDateFormatter  *dateformattor =[[NSDateFormatter  alloc]init];
    [dateformattor setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 =[dateformattor dateFromString:date];
    NSTimeInterval  time =[[NSDate date] timeIntervalSinceDate:date1];
    int day =time/60.0/60.0/24;
    return [NSString stringWithFormat:@" %d天",day];
    
}

+ (NSString *)trainGetFileSizeWithsize:(float )size
{
    float  sizeKB  = size/1024;
    NSString  *str ;
    if(sizeKB <1024.0){
        str =[NSString  stringWithFormat:@"%.2f K",sizeKB];

    }else if(sizeKB/1024.0< 1024.0 ) {
        str =[NSString  stringWithFormat:@"%.2f M",sizeKB/1024.0f];

    }else{
        str =[NSString  stringWithFormat:@"%.2f G",sizeKB/1024.0f/1024.0f];
    }

    return str;
}

+ (NSString *)trainGetFreeSize
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString  *string = [TrainStringUtil trainGetFileSizeWithsize:[freeSpace floatValue]];
    return [NSString  stringWithFormat:@"可用空间: %@",string];
}

+ (NSString  *)traindealSiteHttp:(NSString *)url
{

    if ( ![url hasPrefix:@"http"]) {
        return  [NSString stringWithFormat:@"https://%@",url];
    }
    return url;
}

+ (NSString *)getHostFrom:(NSString *)url{

    if ( ![url hasPrefix:@"http"]) {
       url = [NSString stringWithFormat:@"https://%@",url];
    }
    NSURL  *baseUrl = [NSURL URLWithString:url];
    TrainNSLog(@"---%@",baseUrl.host);
    if ([baseUrl.host isEqualToString:TrainIpText] || [baseUrl.host isEqualToString:TrainHostText] ) {
        return [TrainStringUtil traindealSiteHttp:TrainHostText];
    }
    return url;

}

+ (NSString *)trainLoginPassDate:(NSDate  *)date
{
    NSTimeInterval time =[date timeIntervalSinceNow];
    
    int  mm =time/60;
    int  ss =(int)time % 60;
    NSString *sen =(ss > 9)?[NSString stringWithFormat:@"%d",ss]:[NSString stringWithFormat:@"0%d",ss];
    return [NSString stringWithFormat:@"0%d:%@",mm,sen];
    
}

/** md5  加密 */
NSString * trainMd5String(NSString * str){
    
    
    const char *cStr = [notEmptyStr(str) UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}


NSString *trainCenterWithUser_id(NSString  *userId){
    
    NSDateFormatter  *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date =[dateFormatter stringFromDate:[NSDate date]];
    
    NSString  *userIdSC =[trainMd5String(userId) uppercaseString];
    NSString  *dateSC =[trainMd5String(date) uppercaseString];
    NSString  *zongSC =[NSString stringWithFormat:@"%@%@",userIdSC,dateSC];
    
    return [trainMd5String(zongSC) uppercaseString];
    
    
}

NSString * getCacheSize()
{
    
    //    NSDate* begin = [NSDate date];
    SDImageCache* imageCache = [[SDWebImageManager sharedManager] imageCache];
    NSUInteger fileSize = 0;
    NSUInteger filecount = 0;
    
    //获取SD的缓存
    fileSize = [imageCache getSize];
    filecount =[imageCache getDiskCount];
    if (filecount ==0) {
        return @"";
    }
    NSString* cacheString = [NSString stringWithFormat:@" %.1fM",fileSize/(1024.0*1024)];
    //    NSTimeInterval time = [begin timeIntervalSinceNow];
    //    NSLog(@"便利文件耗费时间:%lf",time/60.0);
    return cacheString;
}
void cleanCacheSize()
{
    SDImageCache* imageCache = [[SDWebImageManager sharedManager] imageCache];
    [imageCache clearDisk];
    [imageCache clearMemory];
}


float  calculateFileSizeInUnit( unsigned long long contentLength){
    if(contentLength >= pow(1024, 3)) { return (float) (contentLength / (float)pow(1024, 3)); }
    else if (contentLength >= pow(1024, 2)) { return (float) (contentLength / (float)pow(1024, 2)); }
    else if (contentLength >= 1024) { return (float) (contentLength / (float)1024); }
    else { return (float) (contentLength); }
}
NSString * calculateUnit( unsigned long long contentLength){
    if(contentLength >= pow(1024, 3)) { return @"G";}
    else if(contentLength >= pow(1024, 2)) { return @"M"; }
    else if(contentLength >= 1024) { return @"K"; }
    else return @"B";
}


+ (NSString *)trainGetNewTime{
    NSDate  *date =[NSDate date];
    NSDateFormatter  *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setDateFormat:@"MM月dd号"];
    return [df stringFromDate:date];

}

+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    
    
    if (!platform) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([platform rangeOfString:@"iPod"].location != NSNotFound) {
            platform = @"iPod Touch";
        }
        else if([platform rangeOfString:@"iPad"].location != NSNotFound) {
            platform = @"iPad";
        }
        else if([platform rangeOfString:@"iPhone"].location != NSNotFound){
            platform = @"iPhone";
        }
    }
    return platform;
}

@end

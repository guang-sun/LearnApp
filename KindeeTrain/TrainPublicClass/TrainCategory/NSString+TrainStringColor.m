//
//  NSString+TrainStringColor.m
//  SOHUTrain
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "NSString+TrainStringColor.h"
#import "TrainMacroDefine.h"


@implementation NSString (TrainStringColor)

-(NSMutableAttributedString *)dealwithstring:(NSString *)str andFont:(CGFloat )font{
    
    return [self dealwithstring:str andFont:font andColor:TrainColorFromRGB16(0xFF1313)];
}
-(NSMutableAttributedString *)dealwithstring:(NSString *)str andFont:(CGFloat )font andColor:(UIColor *)color{
    NSMutableArray  *arr =[NSMutableArray array];
    NSMutableString  *mustr =[self mutableCopy];
    
    while ([mustr rangeOfString:str options:NSCaseInsensitiveSearch |NSBackwardsSearch].location != NSNotFound) {
        NSRange range =[mustr rangeOfString:str options:NSCaseInsensitiveSearch |NSBackwardsSearch];
        NSNumber  *loc =[NSNumber numberWithInteger:range.location];
        [arr addObject:loc];
        [mustr replaceCharactersInRange:range withString:@" "];
    }
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:self];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attstr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([obj integerValue],str.length)];
        [attstr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:trainAutoLoyoutTitleSize(font)] range:NSMakeRange([obj integerValue],str.length)];
    }];
    return attstr;
}

- (NSString *)trainReplaceHtmlCharacter{
    NSString  *html = self.copy;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
}

-(NSMutableAttributedString *)dealWithHtmlImgTagAddWidth{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img.*src=(.*?)[^>]*?>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *imgTagArr = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    NSString  *htmlStr  = self;
    NSMutableString *htmlMuStr = self.mutableCopy;
    for (NSTextCheckingResult *item in imgTagArr) {
        NSString  *hetmlwidth = [NSString stringWithFormat:@"<img width = %.0f",TrainSCREENWIDTH - 70];
        htmlStr = [htmlMuStr stringByReplacingOccurrencesOfString:@"<img" withString:hetmlwidth options:NSCaseInsensitiveSearch range:[item rangeAtIndex:0]];
        htmlMuStr = htmlStr.mutableCopy;
    }
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}
-(NSString *)dealWithHtmlImgTagAddWidthReturnStr{
    
//    NSString *sss = @"<p> <img src=http://eln.sohu-inc.com/upload/ueditor/image/20151201/1448962719669020878.png title=111 alt=icon_folder.png </p>";
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><meta content=\"width= device-width,initial-scale=1.0, maximum-scale=1.0, user-scalable=0 ;\" name=\"viewport\" /><style>img{max-width:%f !important;height:auto !important;} </style></head><body><div style=\"word-break:break-all;\" >%@</div> ",TrainSCREENWIDTH-50  ,self];
    return htmlStr;
}


@end

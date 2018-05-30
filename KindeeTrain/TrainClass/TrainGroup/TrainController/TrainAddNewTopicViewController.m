//
//  TrainAddNewTopicViewController.m
//  SOHUEhr
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年  . All rights reserved.
//

#import "TrainAddNewTopicViewController.h"
#import "TrainCustomTextView.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
//#import "ReadImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIScrollView+TrainScrollTouch.h"
#import "TrainCheckImageViewController.h"
#define   imageItemWidth  (TrainSCREENWIDTH-45)/3

@interface TrainAddNewTopicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate ,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
{
    
    UIButton                *rightBtn;
    NSMutableArray          *imageMuArr;
    NSMutableArray          *imageURLMuArr;

    NSArray                 *tagslist;
    UITextField             *titleTextField;
    UILabel                 *tagTextLab;
    UIScrollView            *contentScrollView;
    TrainCustomTextView     *contentTextView;
    UICollectionView        *imageCollectionview;
    UITableView             *tagTableView;
    
    BOOL                    isTextfield;
    BOOL                    isTextView;
   
    //上传进度
    UIAlertView             *alertView ;
    UIAlertController       *alertController ;
    
    int                     uploadCount;
    
    NSString                *selectTag_id;
    
}
@property(nonatomic,strong)  NSData               *addNewImage;

@end

@implementation TrainAddNewTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = @"发表话题";

    uploadCount = 1;
    isTextfield = NO;
    isTextView  = NO;
    selectTag_id = @"";
    imageURLMuArr  = [NSMutableArray array];
    tagslist = [NSArray array];
    
    rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(TrainSCREENWIDTH - 40, 0, 30, 44);
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.cusFont = 14.0f;
    [rightBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.4] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(updateImage)];
    
    rightBtn.userInteractionEnabled =NO ;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    imageMuArr =[NSMutableArray arrayWithObject:self.addNewImage];
    [self downLoadTopicTag];
    [self creatContentView];

    
    // Do any additional setup after loading the view.
}


#pragma  mark - 获取圈子的标签

-(void)downLoadTopicTag{
    
    [[TrainNetWorkAPIClient client] trainGetTopicTagSuccess:^(NSDictionary *dic) {
       
            tagslist = dic[@"list"];
       
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        
    }];
    
}


#pragma  mark - 上传成功后 拼接image 标签

-(NSString *)getImageContentByImageUrlArr:(NSArray *)arr{
    
    NSMutableString   *muStr = [@"" mutableCopy];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString  *imageURL =obj;
        NSArray   *imageURLArr = [imageURL componentsSeparatedByString:@"/"];
        NSString  *imageName =@"";
        if (!TrainArrayIsEmpty(imageURLArr)) {
            imageName = [imageURLArr lastObject];
        }
        
        NSString  *imageTagStr = [NSString stringWithFormat:@"<p> <img src=%@ title=%@ alt=icon_folder.png </p>",imageURL,imageName];
        
        [muStr appendString:imageTagStr];
        
    }];
    
    return muStr;
    
}



#pragma  mark - 上传进度提示框
-(void)creatAlertView{
    
    if (TrainIOS8 ) {
      
        if ( alertController == nil) {
            NSString  *str = [NSString stringWithFormat:@"0 / %zi",imageMuArr.count - 1];
            
            alertController =[UIAlertController alertControllerWithTitle:TrainUploadingText message:str preferredStyle:UIAlertControllerStyleAlert];
            //        alertController adda
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
       
    }else{
        if(alertView ==nil){
            
            NSString  *str = [NSString stringWithFormat:@"0 / %zi",imageMuArr.count - 1];
            
            alertView = [[UIAlertView alloc]initWithTitle:TrainUploadingText message:str delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
        }

    }
    
}

-(void)updateUploadProgress:(NSString *)str andDismiss:(BOOL)dis{
    if (TrainIOS8) {
        
        alertController.message =str;
        if (dis) {
            [alertController dismissViewControllerAnimated:YES completion:^{
                alertController = nil;
                
            }];
        }

    }else{
       
        alertView.message = str;
        if (dis) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            alertView = nil;
        }

    }
}



#pragma  mark - 上传图片 循环单张
-(void)updateImage{
    
    
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
    
    if (imageMuArr.count > 1) {
        
        
        [self creatAlertView];
        
        if (uploadCount < imageMuArr.count ) {
         

            NSData  *imageData = imageMuArr[uploadCount -1];

            TrainNSLog(@"upload==>>%.2f",imageData.length/1024.0);

            [[TrainNetWorkAPIClient client] trainUploadImage:@[imageData] progress:^(CGFloat progress) {
                
            } Success:^(NSDictionary *dic) {
                
                if ([dic[@"success"] isEqualToString:@"S"]) {
                   
                    NSString  *imageURL = dic[@"imageUrl"];
                   
                    if (uploadCount >= imageMuArr.count - 1) {
                       
                        [imageURLMuArr addObject:imageURL];
                        NSString  *str = [NSString stringWithFormat:@"%zi / %zi",uploadCount,imageMuArr.count - 1];
                        [self updateUploadProgress:str andDismiss:YES];
                        uploadCount = 1;
                        NSString  *imageTagStr = [self getImageContentByImageUrlArr:imageURLMuArr];
                        [self sendNewTopic:imageTagStr];
                        
                    }else{
                        
                        [imageURLMuArr addObject:imageURL];
                        NSString  *str = [NSString stringWithFormat:@"%zi / %zi",uploadCount,imageMuArr.count - 1];
                        uploadCount++;

                        [self updateUploadProgress:str andDismiss:NO];
                        [self updateImage];
                    }
                    
                }else{
                    NSString  *str = [NSString stringWithFormat:@"%zi / %zi",uploadCount,imageMuArr.count - 1];
                    [self updateUploadProgress:str andDismiss:YES];
                    [self trainShowHUDOnlyText:TrainUploadFailText andoff_y:150.0f];
 
                }
            } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
                 NSString  *str = [NSString stringWithFormat:@"%zi / %zi",uploadCount,imageMuArr.count - 1];
                [self updateUploadProgress:str andDismiss:YES];
                [self trainShowHUDOnlyText:TrainUploadFailText andoff_y:150.0f];
                
            }];
        }
    }else{
        [self sendNewTopic:@""];
    }
    

}


#pragma  mark - 图片上传成功后 发表话题
-(void)sendNewTopic:(NSString *)imageStr{
    
    NSString *content;
    if(TrainStringIsEmpty(imageStr)){
        content = contentTextView.text;
    }else{
        content = [NSString stringWithFormat:@"%@\n%@",contentTextView.text,imageStr];
    }
    
    [[TrainNetWorkAPIClient client] trainAddTopicWithGroup_id:_group_id topicTitle:titleTextField.text topicContent:content topic_tagid:selectTag_id Success:^(NSDictionary *dic) {
        
        if ([dic[@"success"] isEqualToString:@"S"]) {
            [self trainShowHUDOnlyText:@"添加成功"];
            if ( _addTopicSuccess) {
                _addTopicSuccess();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
          
        }else{
            [self trainShowHUDOnlyText:dic[@"msg"]];
        }
        
    } andFailure:^(NSInteger errorCode, NSString *errorMsg) {
        [self trainShowHUDOnlyText:@"添加失败"];

    }];
}


#pragma  mark - UI
-(void)creatContentView{
    
    titleTextField  =[[UITextField alloc]init];
    titleTextField.delegate =self;
    titleTextField.placeholder = @"请输入标题(标题限制30字)";
    [titleTextField setValue:TrainColorFromRGB16(0xCACACA)
                  forKeyPath:@"_placeholderLabel.textColor"]; //设置placeholder字体颜色
    [titleTextField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    titleTextField.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:titleTextField];
    titleTextField.sd_layout
    .leftSpaceToView(self.view,TrainMarginWidth)
    .rightSpaceToView(self.view,TrainMarginWidth)
    .topSpaceToView(self.view,TrainNavorigin_y +10)
    .heightIs(20);
    
    UIView  *lineView =[[UIView alloc]init];
    lineView.backgroundColor = TrainColorFromRGB16(0xCACACA);
    [self.view addSubview:lineView];
    
    lineView.sd_layout
    .leftSpaceToView(self.view,TrainMarginWidth)
    .rightSpaceToView(self.view,TrainMarginWidth)
    .topSpaceToView(titleTextField,5)
    .heightIs(0.5);
    
    
    tagTextLab  =[[UILabel alloc]init];
    tagTextLab.text = @"请选择标签";
    tagTextLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:tagTextLab];
    tagTextLab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagTouch)];
    [tagTextLab addGestureRecognizer:tap];

    
    UIButton   *button =[[UIButton alloc]initWithFrame:CGRectZero];
    button.image =[UIImage imageNamed:@"Select_down"];
    button.userInteractionEnabled  = NO;
    [tagTextLab addSubview:button];
    
    
    tagTextLab.sd_layout
    .leftSpaceToView(self.view,TrainMarginWidth)
    .rightSpaceToView(self.view,TrainMarginWidth)
    .topSpaceToView(titleTextField,15)
    .heightIs(20);
    
    button.sd_layout
    .rightSpaceToView(tagTextLab,0)
    .topEqualToView(tagTextLab)
    .widthIs(20)
    .heightIs(20);
    
    
    UIView  *taglineView =[[UIView alloc]init];
    taglineView.backgroundColor = TrainColorFromRGB16(0xCACACA);
    [self.view addSubview:taglineView];
    
    taglineView.sd_layout
    .leftSpaceToView(self.view,TrainMarginWidth)
    .rightSpaceToView(self.view,TrainMarginWidth)
    .topSpaceToView(tagTextLab,5)
    .heightIs(0.5);
    
    
    
    
    contentScrollView = [[UIScrollView alloc]init];
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.userInteractionEnabled  = YES;
    contentScrollView.bounces = YES;
    
    [self.view addSubview:contentScrollView];
    
    contentScrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(taglineView,0)
    .bottomSpaceToView(self.view,0);
    
    contentTextView = [[TrainCustomTextView alloc]init];
    contentTextView.delegate =self;
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.placeholder = @"请输入话题内容(正文限制500字)";
    contentTextView.placeholderColor = TrainColorFromRGB16(0xCACACA);
    [contentScrollView addSubview:contentTextView];
    
    contentTextView.autoresizingMask= UIViewAutoresizingFlexibleHeight;//自适应高度
    
    contentTextView.sd_layout
    .leftSpaceToView(contentScrollView,TrainMarginWidth)
    .rightSpaceToView(contentScrollView,TrainMarginWidth)
    .topSpaceToView(contentScrollView,10)
    .heightIs(contentTextView.font.lineHeight * 7);
    contentTextView.layer.borderWidth = 1.0f;
    
    
    
    
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(imageItemWidth, imageItemWidth);
    layout.minimumInteritemSpacing =5;
    layout.minimumLineSpacing=5;
    imageCollectionview    = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    imageCollectionview.userInteractionEnabled = YES;
    imageCollectionview.delegate = self;
    imageCollectionview.dataSource = self;
    imageCollectionview.backgroundColor = [UIColor whiteColor];
    [imageCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    [contentScrollView addSubview:imageCollectionview];
    

    
    int  num =(imageMuArr.count > 0)?(int)imageMuArr.count / 4 +1 : 0;
    
    imageCollectionview.sd_layout
    .leftSpaceToView(contentScrollView,TrainMarginWidth)
    .rightSpaceToView(contentScrollView,TrainMarginWidth)
    .topSpaceToView(contentTextView,10)
    .heightIs(num * (imageItemWidth + 5));
    
    [contentScrollView setupAutoContentSizeWithBottomView:imageCollectionview bottomMargin:10];
    
}



#pragma  mark - 展示圈子的标签
-(void)showTagTableView{
    
    if (!tagTableView) {
        tagTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tagTableView.delegate =self;
        tagTableView.dataSource = self;
        tagTableView.rowHeight = 30;
        tagTableView.layer.borderWidth = 1.0f;
        tagTableView.layer.cornerRadius = 3.0f;
        [tagTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tagCell"];
        [self.view addSubview:tagTableView];
        
        CGFloat   tagHei = (tagslist.count >0 && tagslist.count <= 5)?tagslist.count * 30:30 * 5 ;
        
        tagTableView.sd_layout
        .leftEqualToView(tagTextLab)
        .rightEqualToView(tagTextLab)
        .topSpaceToView(tagTextLab,6)
        .heightIs(0);
        
        [UIView animateWithDuration:0.3 animations:^{
            tagTableView.sd_layout.heightIs(tagHei);
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            tagTableView.sd_layout.heightIs(0);
        } completion:^(BOOL finished) {
            [tagTableView removeFromSuperview];
            tagTableView = nil;
        }];
       
    }
}

#pragma mark  - textfield  textview   delegate

-(void)tagTouch{
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
    [self showTagTableView];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (tagTableView) {
        [self showTagTableView];
    }
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![string  isEqualToString:@""]) {
        NSString  *titleStr = [textField.text stringByAppendingString:string];
        isTextfield =YES;
        [self changRightBtn];

        if (titleStr.length > 30) {
            textField.text = [titleStr substringToIndex:30];
            
            [self trainShowHUDOnlyText:@"话题标题限制30字内"];

            return NO;
        }
    }else {
        
        isTextfield = (textField.text.length >1)?YES:NO;
        [self changRightBtn];
    }
    return YES;
    
    
}

-(void)changRightBtn{
    if (isTextfield && isTextView) {
        rightBtn.userInteractionEnabled = YES;
        rightBtn.selected = YES;
    }else{
        rightBtn.userInteractionEnabled = NO;
        rightBtn.selected = NO;
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (tagTableView) {
        [self showTagTableView];
    }
    return YES;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    contentTextView.sd_layout
    .heightIs(contentTextView.font.lineHeight * 7);
    contentTextView.scrollEnabled = YES;
    [UIView  animateWithDuration:0.25 animations:^{
        [contentTextView updateLayout];
    }];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (![text  isEqualToString:@""]) {
        isTextView = YES;
        [self changRightBtn];

        NSString  *titleStr = [textView.text stringByAppendingString:text];
        if (titleStr.length > 500) {
            textView.text = [titleStr substringToIndex:500];
            [self trainShowHUDOnlyText:@"话题内容限制500字内"];
            return NO;
        }
    }else{
        isTextView = (textView.text.length >1)?YES:NO;

        [self changRightBtn];

    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView.text.length > 0){
        
        CGSize rect =  [TrainStringUtil trainGetStringSize:textView.text andMaxSize:CGSizeMake(TrainSCREENWIDTH - 40, MAXFLOAT) AndLabelFountSize:14.0f];
        CGFloat   height = rect.height;
        if (height > contentTextView.font.lineHeight * 7 ) {
            contentTextView.sd_layout
            .heightIs(height +20);
            contentTextView.scrollEnabled = NO;
            [UIView  animateWithDuration:0.25 animations:^{
                [contentTextView updateLayout];
            }];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
    if (tagTableView) {
        [self showTagTableView];
    }
    
    
}




#pragma mark  - CollectionView  delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (imageMuArr.count>9)?9:imageMuArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell  *collectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    for (UIView *view in collectCell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView  *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageItemWidth, imageItemWidth)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    if ([imageMuArr[indexPath.row] isKindOfClass:[NSData class]]) {
        imageView.image = [UIImage imageWithData:imageMuArr[indexPath.row]];
    }else{
        [imageView  sd_setImageWithURL:[NSURL URLWithString:imageMuArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"Train_default_image"] options:SDWebImageAllowInvalidSSLCertificates];
        
    }
    
    [collectCell.contentView addSubview:imageView];
    
    return  collectCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView  deselectItemAtIndexPath:indexPath animated:YES];
    
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
    
    if ([self.addNewImage isEqual:imageMuArr[indexPath.row]]) {
        
        [TrainAlertTools showActionSheetWith:self title:@"提示" message:@"添加图片(最多可选9张)" callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex ==1) {
                [self ClickControlAction];
            }else if (btnIndex ==2){
                int   count  = 10 - (int)imageMuArr.count;
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
                imagePickerVc.allowPickingVideo = NO;
                imagePickerVc.allowTakePicture = NO;
                imagePickerVc.allowPickingOriginalPhoto =NO;
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }
        } destructiveButtonTitle:nil cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"本地相册", nil];
        
        
        
    }else {
        TrainCheckImageViewController *checkVC =[[TrainCheckImageViewController alloc]init];
        checkVC.photoArr = imageMuArr;
        checkVC.currentIndex = indexPath.row;
        checkVC.returnNewPhotoArrBlock = ^(NSMutableArray *arr){
            
            imageMuArr = [NSMutableArray arrayWithArray:arr];
            [imageMuArr addObject:self.addNewImage];
            [self updateCollectionFram];
        };
        
        [self.navigationController  pushViewController:checkVC animated:YES];
    }
    
}

#pragma mark - tags  tableView  delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tagslist?tagslist.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tagCell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
    NSDictionary   *dic = tagslist[indexPath.row];
    tagCell.textLabel.text = dic[@"name"];
    tagCell.textLabel.cusFont = 14.f;
    
    return tagCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary   *dic = tagslist[indexPath.row];
    tagTextLab.text =dic[@"name"];
    [tagTableView removeFromSuperview];
    tagTableView =nil;
    selectTag_id = [dic[@"tag_id"] stringValue];
}



#pragma mark - 拍照按钮事件

// 判断程序的隐私设置是否授予权限

-(BOOL)isHavePhotopermissions{
    if(TrainIOS7){
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
        {
            return NO;
        }else
        {
            return YES;
        }
    }else{
        return YES;
    }
}


- (void)ClickControlAction{
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [self isHavePhotopermissions]){
        // 初始化图片选择控制器
        
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
//        controller.allowsEditing = YES;   // 设置是否可以管理已经存在的图片或者视频
        controller.delegate = self;
        
        [self.navigationController presentViewController:controller animated:YES completion:^{
            
        }];
    } else {
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString  *str = [NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项中，\r允许%@访问您的相机。",[UIDevice currentDevice].model,appName];
        
        [TrainAlertTools showAlertWith:self title:@"未获得授权使用摄像头" message:str callbackBlock:^(NSInteger btnIndex) {
            
            if (btnIndex == 1) {
                if (iOS8Later) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
                }
            }
            
        } cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:@"设置", nil];
        
    }
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 判断获取类型：图片
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        theImage = [UIImage fixOrientation:theImage];
        
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(theImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
       
        NSData  *addImage = [theImage compressImageMaxFileSize:100];

//        NSData * imageData = UIImageJPEGRepresentation(theImage,1);

        
        TrainNSLog(@"%.2f",addImage.length/1024.0);

        [imageMuArr removeLastObject];
        [imageMuArr addObject:addImage];
        [imageMuArr addObject:self.addNewImage];

        [self updateCollectionFram];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}

// 当用户取消时，调用该方法

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}



#pragma mark TZImagePickerControllerDelegate

/// User finish picking photo，if assets are not empty, user picking original photo.
/// 用户选择好了图片，如果assets非空，则用户选择了原图。

-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if (isSelectOriginalPhoto) {
        [imageMuArr removeLastObject];

//        [self trainShowHUDOnlyActivity];
//        [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [[TZImageManager manager] getOriginalPhotoWithAsset:obj completion:^(UIImage *photo, NSDictionary *info) {
//
//                NSData  *data = UIImageJPEGRepresentation(photo, 1.0);
//                [imageMuArr addObject:data];
//                
//                if (idx == assets.count -1) {
//                    [self trainHideHUD];
//                    [imageMuArr addObject:self.addNewImage];
//                    [self updateCollectionFram];
//                }
//
//            }];
//            
//        }];
      

        
    }else{
        [imageMuArr removeLastObject];

        for ( UIImage   *image  in  photos) {
            NSData  *addImage = [image compressImageMaxFileSize:100];
            
            [imageMuArr addObject:addImage];
            
            TrainNSLog(@"111==>%.2f",addImage.length/ 1024.0);
        }
        [imageMuArr addObject:self.addNewImage];
        [self updateCollectionFram];

    }

}


-(void)updateCollectionFram{
    int  num =(imageMuArr && imageMuArr.count < 10)?(int)(imageMuArr.count - 1) / 3 +1 : 3 ;
    imageCollectionview.sd_layout
    .heightIs(num * (imageItemWidth + 5));
    [imageCollectionview updateLayout];
    [imageCollectionview reloadData];
    
}




/**
 *  添加 +  图片 按钮
 *
 *  @return
 */

-(NSData *)addNewImage{
    if (!_addNewImage) {
        UIImage  *image = [UIImage  imageNamed:@"Train_image_add_nor"];
        _addNewImage = UIImageJPEGRepresentation(image, 1);
    }
    return _addNewImage;
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

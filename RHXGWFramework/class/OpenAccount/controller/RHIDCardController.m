 //
//  RHIDCardController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/8.
//
//

#import "RHIDCardController.h"
#import "OARequestManager.h"

#import "IDCardViewController.h"
#import "IDCardResultViewController.h"
#import "IDPhoto.h"

#import "UploadIdCardView.h"
#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

static NSString * idImgPatah = @"idImgPatah";

@interface RHIDCardController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IDCamCotrllerDelegate,IDPhotoDelegate>
//@property (strong, nonatomic) IBOutlet UIImageView *frontIDCardImgView;
//@property (strong, nonatomic) IBOutlet UIImageView *backIDCardImgView;
//- (IBAction)nextStepBtn:(id)sender;

kRhPStrong UIScrollView * bottomScrollview;

kRhPStrong UploadIdCardView *frontIDCardImgView;
kRhPStrong UploadIdCardView *backIDCardImgView;

kRhPStrong UILabel * hintLabel;

kRhPStrong UIButton * nextBtn;

kRhPCopy NSString * tagStr;

kRhPStrong UIImage * selectImg;

kRhPStrong UIImage * frontImg;

kRhPStrong NSData * frontData;

kRhPStrong NSData * backData;

kRhPStrong UIImage * backImg;

kRhPStrong OARequestManager * checkManager;

kRhPStrong NSMutableArray * managerArr;
kRhPAssign NSInteger managerNum;

kRhPCopy NSString * client_id;
//- (IBAction)uploadFrontImg:(id)sender;
//- (IBAction)uploadBackImg:(id)sender;

kRhPStrong IdInfo * idInfo;

kRhPStrong NSString * dataStr;

kRhPAssign CGFloat imgRatio;

kRhPAssign BOOL needRectify;

kRhPStrong IDPhoto * idPhoto;

@end

@implementation RHIDCardController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"影像上传";
        self.idInfo = [[IdInfo alloc] init];
        self.view.backgroundColor = color1_text_xgw;
        self.managerArr = [NSMutableArray array];
        self.needRectify = NO;

        [self initSubviews];

    }
    return self;
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        return;
    }
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = universalParam;
        if ([dic objectForKey:@"hiddenBack"]) {
            self.backButtonHidden = [[dic objectForKey:@"hiddenBack"] boolValue];
        }
        if ([dic objectForKey:kOpenAccountRectify]) {
            self.needRectify = [[dic objectForKey:kOpenAccountRectify] boolValue];
        }
    }
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (OARequestManager *)checkManager{
    if (!_checkManager) {
        _checkManager = [[OARequestManager alloc] init];
    }
    return _checkManager;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    IDCardViewController * idVc = [[IDCardViewController alloc] init];
//    idVc.IDCamDelegate = self;
//    idVc.bShouldFront = YES;
//    [self.navigationController pushViewController:idVc animated:YES];
//    
//    return;
//    if ([RHOpenAccStoreData loadOpenAccountDataWithPath:idImgPatah]) {
//        NSDictionary * dic = [RHOpenAccStoreData loadOpenAccountDataWithPath:idImgPatah];
//        self.frontImg = [dic objectForKey:@"front"];
//        self.backImg = [dic objectForKey:@"back"];
//        if (self.frontImg) {
//            [self.frontIDCardImgView setImage:self.frontImg];
//        }
//        if (self.backImg) {
//            [self.backIDCardImgView setImage:self.backImg];
//        }
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.checkManager cancelAllDelegate];
    
    for (OARequestManager * manager in self.managerArr) {
        [manager cancelAllDelegate];
    }

}

- (void)initSubviews{
    self.bottomScrollview = [[UIScrollView alloc] init];
    [self.view addSubview:self.bottomScrollview];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"注：请保持身份证四边框清晰完整，背景干净" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
    [self.bottomScrollview addSubview:self.hintLabel];
    
    self.frontIDCardImgView = [[UploadIdCardView alloc] initFrontView];
    [self.bottomScrollview addSubview:self.frontIDCardImgView];
    
    self.backIDCardImgView = [[UploadIdCardView alloc] initBackView];
    [self.bottomScrollview addSubview:self.backIDCardImgView];
    
    self.nextBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    self.nextBtn.enabled = NO;
    [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    self.frontIDCardImgView.userInteractionEnabled = YES;
    self.backIDCardImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadFrontIDCard)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadBackIDCard)];
    
    [self.frontIDCardImgView addGestureRecognizer:tap1];
    [self.backIDCardImgView addGestureRecognizer:tap2];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bottomScrollview.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - 58.0f - self.layoutStartY);
    
    self.hintLabel.frame = CGRectMake(24.0, 0, self.bottomScrollview.width - 48.0f, 50.0f);
    
    self.frontIDCardImgView.frame = CGRectMake(24.0f, CGRectGetMaxY(self.hintLabel.frame), self.bottomScrollview.width - 48.0f, 197.0f);
    
    self.backIDCardImgView.frame = CGRectMake(self.frontIDCardImgView.x, CGRectGetMaxY(self.frontIDCardImgView.frame) + 24.0f, self.frontIDCardImgView.width, self.frontIDCardImgView.height);

//    self.frontIDCardImgView.frame = CGRectMake(24.0f, CGRectGetMaxY(self.hintLabel.frame), self.frontIDCardImgView.width, self.frontIDCardImgView.height);
//    self.backIDCardImgView.frame = CGRectMake(24.0f, CGRectGetMaxY(self.hintLabel.frame), self.backIDCardImgView.width, self.backIDCardImgView.height);

    self.nextBtn.frame = CGRectMake((self.view.width - self.nextBtn.width)/2.0f, self.view.height - self.nextBtn.height - 14.0f, self.nextBtn.width, self.nextBtn.height);
    
    self.bottomScrollview.contentSize = CGSizeMake(self.bottomScrollview.width, CGRectGetMaxY(self.backIDCardImgView.frame) + 10.0f);
}

-(void)didEndRecIDWithResult:(IdInfo* ) idInfo from:(id)sender{
    
    
//    code; //身份证号
//    name; //姓名
//    gender; //性别
//    nation; //民族
//    address; //地址
//    issue; //签发机关
//    valid; //有效期
    [self dealTheIdResult:idInfo];

}

-(void)didFinishPhotoRec{
    
}

-(void)returnIDPhotoResult:(IdInfo *)idInfo from:(id)sender{
    [self dealTheIdResult:idInfo];
    
}

- (void)dealTheIdResult:(IdInfo *)idInfo{
    NSString * idNum = idInfo.code;
    UIImage * faceImg = idInfo.fullImg;
    if (!faceImg) {
        [CMProgress showWarningProgressWithTitle:nil message:@"未识别到您的身份证，请重新识别" warningImage:nil duration:2];
        return;
    }
    //    UIImage * faceImg = idInfo.faceImg;
    if ([self.tagStr isEqualToString:@"front"]) {
        if ((!idInfo.name.length || !idInfo.address.length || !idInfo.code.length) && idInfo.issue.length) {
            //识别的是背面照片
            [CMProgress showWarningProgressWithTitle:nil message:@"请重新识别身份证正面照片" warningImage:nil duration:2];

            return;
        }
        
        self.frontImg = faceImg;
        //        self.frontIDCardImgView.idImg = self.frontImg;
        
        UIImageView * imgf = [[UIImageView alloc] initWithImage:faceImg];
        self.imgRatio = imgf.width /imgf.height;
        [self.frontIDCardImgView loadIdImgWith:self.frontImg withRatio:self.imgRatio];
        
        
        self.idInfo.code = idInfo.code;
        self.idInfo.name = idInfo.name;
        self.idInfo.gender = idInfo.gender;
        self.idInfo.nation = idInfo.nation;
        self.idInfo.address = idInfo.address;
        self.idInfo.connectAddress = idInfo.address;
        
        NSMutableString * str = [NSMutableString stringWithString:self.idInfo.code];
        self.idInfo.birthday = [str substringWithRange:NSMakeRange(6, 8)];
        
        CGFloat width = 282.0f;
        CGFloat height = 0.0;
        if (self.imgRatio != 0.0f) {
            height =  width / self.imgRatio;
        }
        
        NSData *imageData = UIImageJPEGRepresentation([self OriginImage:self.frontImg scaleToSize:CGSizeMake(width,height)],0.5);
        self.frontData = imageData;
        
    }
    else{
        if ((idInfo.name.length || idInfo.address.length || idInfo.code.length) && !idInfo.issue.length) {
            //识别的是正面照片
            [CMProgress showWarningProgressWithTitle:nil message:@"请重新识别身份证背面照片" warningImage:nil duration:2];
            
            return;
        }

        
        self.backImg = faceImg;
        //        self.backIDCardImgView.idImg = self.backImg;
        
        UIImageView * imgf = [[UIImageView alloc] initWithImage:faceImg];
        self.imgRatio = imgf.width /imgf.height;
        [self.backIDCardImgView loadIdImgWith:self.backImg withRatio:self.imgRatio];
        
        self.idInfo.issue = idInfo.issue;
        self.idInfo.valid = idInfo.valid;
        
        if (self.idInfo.valid.length == 17) {
            self.idInfo.beginDate = [self.idInfo.valid substringToIndex:8];
            self.idInfo.endDate = [self.idInfo.valid substringFromIndex:9];
        }
        else if (self.idInfo.valid.length == 11){//长期
            self.idInfo.beginDate = [self.idInfo.valid substringToIndex:8];
            
        }
        CGFloat width = 282.0f;
        CGFloat height = 0.0;
        if (self.imgRatio != 0.0f) {
            height =  width / self.imgRatio;
        }
        NSData *imageData = UIImageJPEGRepresentation([self OriginImage:self.backImg scaleToSize:CGSizeMake(width,height)],0.5);
        
        self.backData = imageData;
        
        
    }
    if (self.frontImg && self.backImg) {
        self.nextBtn.enabled = YES;
    }
    
    [self.view setNeedsLayout];

}

- (void)uploadFrontIDCard{
    self.tagStr = @"front";
    [self getPhotoIdCard];
}

- (void)uploadBackIDCard{
    self.tagStr = @"back";
    [self getPhotoIdCard];
}

- (void)getPhotoIdCard{
//    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", nil];
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];

    [action showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
         [self photoFromCamera];
    }
    else if (buttonIndex == 1){
//        [self photoFromAlbums];
        self.idPhoto = [[IDPhoto alloc] init];
        self.idPhoto.target = self;
        self.idPhoto.delegate = self;
        [self.idPhoto photoReco];
    }
//    else{
//        
//    }
}

/**
 *  拍照
 */
-(void)photoFromCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [CMProgress showWarningProgressWithTitle:nil message:@"照相机不能使用" warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
        return;
    }
    
    IDCardViewController * idVc = [[IDCardViewController alloc] init];
    idVc.IDCamDelegate = self;
    if ([self.tagStr isEqualToString: @"front"]) {
        idVc.bShouldFront = YES;

    }
    else if ([self.tagStr isEqualToString:@"back"]){
        idVc.bShouldFront = NO;

    }
    [self.navigationController pushViewController:idVc animated:YES];
    
}

/**
 *  从相册中选择
 */
-(void)photoFromAlbums{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        [CMProgress showWarningProgressWithTitle:nil message:@"相册不能使用" warningImage:img_progress_warning duration:kPopupWindowDurationInterval];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
/**
 *  选择图片后处理
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    [CMProgress showBeginProgressWithMessage:@"正在上传" superView:self.view];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
       self.selectImg  = [info valueForKey:UIImagePickerControllerEditedImage];
        
        NSData *imageData = UIImageJPEGRepresentation([self OriginImage:self.selectImg scaleToSize:CGSizeMake(_frontIDCardImgView.width, _frontIDCardImgView.height)],0.5);
        self.dataStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        if ([self.tagStr isEqualToString:@"front"]) {
//            self.frontIDCardImgView.idImg = /.selectImg;
            [self.frontIDCardImgView loadIdImgWith:self.selectImg withRatio:1.59];
            self.frontImg = self.selectImg;
            self.frontData = imageData;
        }
        else if ([self.tagStr isEqualToString:@"back"]){
//            self.backIDCardImgView.idImg = self.selectImg;
            [self.backIDCardImgView loadIdImgWith:self.selectImg withRatio:1.59];

            self.backImg = self.selectImg;
            self.backData = imageData;
        }
        if (self.frontImg && self.backImg) {
            self.nextBtn.enabled = YES;
        }

        
        [self.view setNeedsLayout];
        
    }];
}

// 改变图像的尺寸，方便上传服务器
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)nextClick:(id)sender {
    if (!self.frontImg || !self.backImg) {
        return;
    }
    
    self.nextBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.nextBtn.enabled = YES;
    });
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:self.frontImg forKey:@"front"];
    [dic setObject:self.backImg forKey:@"back"];
    [RHOpenAccStoreData saveOpenAccountData:dic withPath:idImgPatah];
    
    //识别到身份证信息 需要判断是否符合开户条件
    [self checkIfUserCanOpenAcc];
    
//    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHVideoRECController" withParam:nil];
    
}

- (void)checkIfUserCanOpenAcc{
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    if (!self.idInfo.code.length || !self.idInfo.name.length) {
//        [param setObject:self.client_id forKey:@"client_id"];
//        [param setObject:@"110111198901101826" forKey:@"id_no"];
//        [param setObject:@"0" forKey:@"id_kind"];
//        [param setObject:@"李岩" forKey:@"client_name"];
        return;
    }
    else{
    
        [param setObject:self.client_id forKey:@"client_id"];
        [param setObject:self.idInfo.code forKey:@"id_no"];
        [param setObject:@"0" forKey:@"id_kind"];
        [param setObject:self.idInfo.name forKey:@"client_name"];
    }
    __weak typeof(self) welf = self;
    [self.checkManager sendCommonRequestWithParam:param withRequestType:kCheckCanOpenAcc withUrlString:@"crhCheckCanOpenAcc" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            //上传身份证
            [welf.managerArr removeAllObjects];
            welf.managerNum = 0;
            [welf uploadFrontImg];
            [welf uploadBackImg];

        }
        else{
            NSString * error_info = [resultData objectForKey:@"error_info"];
            
            [CMProgress showWarningProgressWithTitle:nil message:error_info warningImage:nil duration:3.0];
        }
    }];

}


- (void)upLoadIdImgToServerWithParam:(NSDictionary *)aParam{
    
    OARequestManager * upLoadManager = [[OARequestManager alloc] init];
    
    __weak typeof(self) welf = self;
    [upLoadManager requestUploadPersonIdImgToSever:aParam withRequestType:kUploadPersonIdImg withCompletion:^(BOOL success, id resultData) {
        welf.managerNum++;
        if (success) {
            NSString * image_url = [resultData objectForKey:@"image_url"];
            
        }
        if ([welf checkIfupLoadIdImgComplete]) {
            //跳转
//            if (!self.idInfo.code.length || !self.idInfo.name.length) {
//                [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAPersonalInfoConfirmController" withParam:nil];
//                return;
//            }
            if (self.needRectify) {
                NSMutableDictionary * param = [NSMutableDictionary dictionary];
                [param setObject:@1 forKey:kOpenAccountRectify];
                [param setObject:self.idInfo forKey:@"idInfo"];
                 [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAPersonalInfoConfirmController" withParam:param];
            }
            else{
                [MNNavigationManager navigationToUniversalVC:self withClassName:@"OAPersonalInfoConfirmController" withParam:self.idInfo];
            
            }
        }
        
    }];
    [self.managerArr addObject:upLoadManager];

}

- (BOOL)checkIfupLoadIdImgComplete{
    if (self.managerNum == self.managerArr.count) {
        return YES;
    }
    return NO;
}


- (NSString *)typeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @".jpeg";
            
        case 0x89:
            
            return @".png";
            
        case 0x47:
            
            return @".gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @".tiff";
            
    }
    
    return nil;
    
}
- (void)uploadFrontImg{
    if (!self.frontData) {
        return;
    }

    NSString * phoneNum = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccMobile];
    if (!self.client_id.length || !phoneNum.length) {
        return;
    }
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:phoneNum forKey:@"mobile_tel"];
    
    [param setObject:@"6A" forKey:@"image_no"];
    
    self.dataStr = [self.frontData base64EncodedStringWithOptions:0];
    
    if (!self.dataStr || !self.dataStr.length) {
        
        return;
    }
    [param setObject:self.dataStr forKey:@"image_data"];
    
//    [param setObject:self.frontData forKey:@"image_data"];
    NSString * type = [self typeForImageData:self.frontData];
    [param setObject:type forKey:@"image_type"];
    [self upLoadIdImgToServerWithParam:param];
    
}

- (void)uploadBackImg{
    if (!self.backData) {
        return;
    }

    NSString * phoneNum = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccMobile];

    if (!self.client_id.length || !phoneNum.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:phoneNum forKey:@"mobile_tel"];
    
    [param setObject:@"6B" forKey:@"image_no"];
    
    self.dataStr = [self.backData base64EncodedStringWithOptions:0];
    
    if (!self.dataStr || !self.dataStr.length) {
        
        return;
    }
    [param setObject:self.dataStr forKey:@"image_data"];
    
    NSString * type = [self typeForImageData:self.backData];
    [param setObject:type forKey:@"image_type"];
    [self upLoadIdImgToServerWithParam:param];

}



@end

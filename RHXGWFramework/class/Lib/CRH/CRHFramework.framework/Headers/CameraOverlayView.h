//
//  CameraOverlayView.h
//  crh-sjkh
//
//  Created by Ring on 14-7-15.
//  Copyright (c) 2014年 com.cairh. All rights reserved.
//

#import <UIKit/UIKit.h>
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
//获取设备的物理高度
#define SCHEIGHT [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define SCWIDTH [UIScreen mainScreen].bounds.size.width
//获取当前设备版本号
#define IOS_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
@interface CameraOverlayView : UIView<UITextViewDelegate>

@property (nonatomic,assign) NSInteger flag;
@property (nonatomic, retain) NSString *picType;
@property (nonatomic) NSUInteger page;
@property (nonatomic) NSUInteger msgIndex;
@property (nonatomic) NSUInteger showMsgLength;
@property (nonatomic) BOOL rifImg;
@property (nonatomic, retain) NSArray *msg;

//-(void)beginVideo;
//-(void)removeRectBord:(id)sender;
-(void)nextPage:(id)sender;
-(id)initWithFrame:(CGRect)frame picType:(NSString*) picType;

@end

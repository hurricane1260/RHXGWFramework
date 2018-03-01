//
//  RevisitChooseView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import <UIKit/UIKit.h>

@interface RevisitChooseView : UIView

kRhPCopy ButtonCallBackWithParams selectCallBack;
kRhPCopy ButtonCallBackWithParams widthCallBack;


- (instancetype)initWithContent:(NSString * )str andDefaultSelet:(NSNumber *)defaultSelet;
@end

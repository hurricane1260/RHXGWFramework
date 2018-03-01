//
//  ApplyFinishView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/3.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger{
    applyingType,//开户申请已提交
    failType,//开户申请未通过
    successType,//开户成功
    
}TagType;


@interface ApplyFinishView : UIView

- (instancetype)initWithType:(TagType) type withData:(id)resultData;

kRhPCopy ButtonCallBackWithParams heightCallBack;

kRhPCopy NSString * errorReason;
@end

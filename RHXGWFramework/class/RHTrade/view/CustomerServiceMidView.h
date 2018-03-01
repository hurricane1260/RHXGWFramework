//
//  CustomerServiceMidView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/3.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,TapType ) {
    
    
    WXType = 0,
    
    QQType = 1,
    
    WeChatPublic = 2,
    
    /**小E*/
    EType = 3,
    /**牛大发*/
    NType = 4
    
};

typedef void (^tapBlock)(NSString *number,TapType type);

@interface CustomerServiceMidView : UIView
@property (nonatomic,copy)tapBlock tapBlock;

@end

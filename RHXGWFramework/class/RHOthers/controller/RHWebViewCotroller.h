//
//  RHWebViewCotroller.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/14.
//
//

#import "BaseViewController.h"

//通用webview 无分享可不传此参数 用去区分分享内容
typedef enum :NSInteger{
    operateSignalWebType = 1,//操作信号
    newsDetailWebType,//新闻详情页

}webType;

@interface RHWebViewCotroller : BaseViewController

kRhPStrong id param;

kRhPAssign webType webViewType;
@end

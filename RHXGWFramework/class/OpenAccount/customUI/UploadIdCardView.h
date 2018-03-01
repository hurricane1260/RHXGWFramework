//
//  UploadIdCardView.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/26.
//
//

#import <UIKit/UIKit.h>

@interface UploadIdCardView : UIView

- (instancetype)initFrontView;

- (instancetype)initBackView;

- (void)loadIdImgWith:(UIImage *)img withRatio:(CGFloat)ratio;

kRhPStrong UIImage * idImg;

@end

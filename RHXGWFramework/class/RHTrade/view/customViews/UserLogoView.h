//
//  FXUserLogoView.h
//  fanxing
//
//  Created by zhanghang on 16/4/6.
//

#import <UIKit/UIKit.h>

@interface UserLogoView : UIView



/** 头像拉伸模式 */
@property(nonatomic, assign)UIViewContentMode contentMode;
/**头像是否是圆的*/
@property (nonatomic,assign) BOOL roundLogo;
/** 头像的URL， 可以是网络也可发以是本地 */
@property(nonatomic, copy)NSString *logoUrl;
/** 头像的URL， 可以是网络也可发以是本地 */
@property(nonatomic, copy)NSString *defaultLogoUrl;
/**logoUrl为头像图片地址   defaultLogoUrl为默认本地图片地址*/
-(instancetype)initWithLogoUrl:(NSString *)logoUrl;
/**logoUrl为头像图片地址   defaultLogoUrl为默认本地图片地址*/
-(instancetype)initWithLogoUrl:(NSString *)logoUrl defaultLogo:(NSString *)defaultLogoUrl;
/**logoUrl为头像图片地址   defaultLogoUrl为默认本地图片地址*/
-(void)setImageWithUrl:(NSString*)url defaultImageUrl:(NSString*)defaultUrl;
/**logoUrl为头像图片地址   defaultLogoImage为默认本地图片*/
-(void)setImageWithUrl:(NSString*)url defaultLogoImage:(UIImage*)defaultImage;
/*为头像描边*/
-(void)drawBorderColor:(UIColor *)color Width:(CGFloat) width;
/**logoUrl为头像图片地址   defaultLogoUrl为默认本地图片地址*/
+(instancetype)userLogoImageViewWithLogoUrl:(NSString *)logoUrl;
/**logoUrl为头像图片地址   defaultLogoUrl为默认本地图片地址*/
+(instancetype)userLogoImageViewWithLogoUrl:(NSString *)logoUrl defaultLogo:(NSString *)defaultLogoUrl;

-(void)setImage:(UIImage *)image;
@end

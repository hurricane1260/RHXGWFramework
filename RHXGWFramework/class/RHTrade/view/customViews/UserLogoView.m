//
//  FXUserLogoView.m
//  fanxing
//
//  Created by zhanghang on 16/4/6.
//

#import "UserLogoView.h"
#import "UIImageView+WebCache.h"

@interface UserLogoView()
/** 圆角遮罩 */
@property(nonatomic, weak)CAShapeLayer *shapeLayer;
/** 头像 */
@property (nonatomic, weak) UIImageView *logoImgView;



@end
@implementation UserLogoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.roundLogo = YES;
        UIImageView* logoImgView = [[UIImageView alloc]initWithFrame:self.bounds];
        logoImgView.contentMode = UIViewContentModeScaleToFill;
        logoImgView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/BMyTab_head_me"];
        [self addSubview:logoImgView];
        self.logoImgView = logoImgView;
        //加圆形遮罩
        CAShapeLayer*  shapeLayer = [CAShapeLayer layer];
        self.shapeLayer = shapeLayer;
        self.logoImgView.layer.mask = shapeLayer;
        self.shapeLayer.frame = self.bounds;
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(instancetype)initWithLogoUrl:(NSString *)logoUrl
{
    if (self = [super init]) {
        if(logoUrl==nil || logoUrl.length==0)
        {
            self.roundLogo = YES;
            return self;
        }
        [self setImage:logoUrl defaultLogo:nil];
        self.roundLogo = YES;
    }
    return self;
}

-(instancetype)initWithLogoUrl:(NSString *)logoUrl defaultLogo:(NSString *)defaultLogoUrl
{
    if (self = [super init])
    {
        if(logoUrl==nil || logoUrl.length==0 || defaultLogoUrl==nil || defaultLogoUrl.length==0)
        {
            self.roundLogo = YES;
            return self;
        }
        [self setImage:logoUrl defaultLogo:defaultLogoUrl];
        self.roundLogo = YES;
    }
    return self;
}

+(instancetype)userLogoImageViewWithLogoUrl:(NSString *)logoUrl{
    UserLogoView *temp =[[UserLogoView alloc]initWithLogoUrl:logoUrl];
    return temp;
}

+(instancetype)userLogoImageViewWithLogoUrl:(NSString *)logoUrl defaultLogo:(NSString *)defaultLogoUrl{
    UserLogoView *temp = [[UserLogoView alloc]initWithLogoUrl:logoUrl defaultLogo:defaultLogoUrl];
    return temp;
}

-(void)setImageWithUrl:(NSString*)url defaultImageUrl:(NSString*)defaultUrl
{
    defaultUrl = [NSString stringWithFormat:@"Frameworks/RHXGWFramework.framework/%@",defaultUrl];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:defaultUrl] options:SDWebImageLowPriority | SDWebImageDelayPlaceholder];
}

/**logoUrl为头像图片地址   defaultLogoImage为默认本地图片*/
-(void)setImageWithUrl:(NSString*)url defaultLogoImage:(UIImage*)defaultImage
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/BMyTab_head_me"];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolderImage options:SDWebImageLowPriority | SDWebImageDelayPlaceholder];
}

-(void)setImage:(UIImage *)image
{
    self.logoImgView.image = image;
}

-(void)setRoundLogo:(BOOL)roundLogo
{
    _roundLogo = roundLogo;
    self.shapeLayer.hidden = !roundLogo;
}

-(void)setLogoUrl:(NSString *)logoUrl
{
    _logoUrl = logoUrl;
    [self setImage:logoUrl defaultLogo:@"BMyTab_head_me"];
}

-(void)setContentMode:(UIViewContentMode)contentMode
{
    if(_contentMode != contentMode)
    {
        _contentMode = contentMode;
        self.logoImgView.contentMode = contentMode;
    }
}

-(void)setImage:(NSString *)logoUrl defaultLogo:(NSString *)defaultLogoUrl
{
    if(defaultLogoUrl==nil || defaultLogoUrl.length==0)
    {
        if ([logoUrl hasPrefix:@"http"]||[logoUrl hasPrefix:@"https"])
        {
            NSURL *imgUrl = [NSURL URLWithString:logoUrl];
            [self.logoImgView sd_setImageWithURL:imgUrl];
        }
        else
        {
            self.logoImgView.image = [UIImage imageNamed:logoUrl];
            if (self.logoImgView.image == nil) {
                self.logoImgView.image = [UIImage imageNamed:defaultLogoUrl];
                
            }
        }
        
    }
    else
    {
        NSURL *imgUrl = [NSURL URLWithString:logoUrl];
        if ([logoUrl hasPrefix:@"http"]||[logoUrl hasPrefix:@"https"])
        {
            [self.logoImgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:defaultLogoUrl] options:SDWebImageLowPriority | SDWebImageDelayPlaceholder];
        }
        else
        {
            if ([self isStringEmpty:logoUrl]) {
                
                [self.logoImgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:defaultLogoUrl]];

            }else{
                self.logoImgView.image = [UIImage imageNamed:logoUrl];
                if (self.logoImgView.image == nil) {
                    self.logoImgView.image = [UIImage imageNamed:defaultLogoUrl];

                }

            }
            
        }
    }
}
/** 判断字符串是否为空 */
-(BOOL)isStringEmpty:(NSString*)str
{
    return str==nil || str.length==0 ||[str isEqual:[NSNull null]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logoImgView.frame = self.bounds;
    self.shapeLayer.frame = self.bounds;
    
    if (self.roundLogo)
    {
        if(!self.shapeLayer.path)
        {
            //圆角
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
            self.shapeLayer.path = path.CGPath;
        }
        self.logoImgView.layer.mask = self.shapeLayer;
    }else
    {
        self.logoImgView.layer.mask = nil;
    }
    

}

-(void)drawBorderColor:(UIColor *)color Width:(CGFloat) width
{
//    // 设置线宽
//    self.shapeLayer.borderWidth = 2;
//    // 设置线的颜色
//    self.shapeLayer.borderColor = color.CGColor;
}

@end

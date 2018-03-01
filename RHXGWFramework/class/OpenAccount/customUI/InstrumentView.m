//
//  InstrumentView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/13.
//
//

#import "InstrumentView.h"
#import "CRHRiskResultVo.h"
#define Calculate_radius ((self.bounds.size.height>self.bounds.size.width)?(self.bounds.size.width*0.5-self.lineWidth):(self.bounds.size.height*0.5-self.lineWidth))
#define LuCenter CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y)

@interface InstrumentView ()
/**
 *  圆盘开始角度
 */
@property(nonatomic,assign)CGFloat startAngle;
/**
 *  圆盘结束角度
 */
@property(nonatomic,assign)CGFloat endAngle;
/**
 *  圆盘总共弧度弧度
 */
@property(nonatomic,assign)CGFloat arcAngle;
/**
 *  线宽
 */
@property(nonatomic,assign)CGFloat lineWidth;
/**
 *  刻度值长度
 */
@property(nonatomic,assign)CGFloat scaleValueRadiusWidth;
/**
 *  速度表半径
 */
@property(nonatomic,assign)CGFloat arcRadius;
/**
 *  刻度半径
 */
@property(nonatomic,assign)CGFloat scaleRadius;
/**
 *  刻度值半径
 */
@property(nonatomic,assign)CGFloat scaleValueRadius;


@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic,strong) UILabel * typeLb;
@property (nonatomic,strong) UILabel * subTitle;

@end
@implementation InstrumentView

-(UILabel *)typeLb{
    if (!_typeLb) {
        _typeLb = [[UILabel alloc]init];
        _typeLb.size = CGSizeMake(150, 40);
        _typeLb.center =CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y-20);
        _typeLb.textColor = color6_text_xgw;
        _typeLb.font =  [UIFont systemFontOfSize:27];
        _typeLb.textAlignment = NSTextAlignmentCenter;
//        _typeLb.backgroundColor = [UIColor redColor];
        [self addSubview:_typeLb];
    }
    
    return _typeLb;
}
-(UILabel *)subTitle{
    if (!_subTitle) {
        _subTitle = [[UILabel alloc]init];
        _subTitle.size = CGSizeMake(100, 30);
        _subTitle.center = CGPointMake(self.typeLb.center.x, self.typeLb.center.y+self.typeLb.size.height/2+10);
//        _subTitle.backgroundColor = [UIColor yellowColor];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.font = font2_common_xgw;
        _subTitle.textColor = color4_text_xgw;
        [self addSubview:_subTitle];
    }
    
    
    return _subTitle;
    
}
/**
 *  画底层弧度
 *
 *  @param startAngle  开始角度
 *  @param endAngle    结束角度
 *  @param lineWitdth  线宽
 *  @param filleColor  扇形填充颜色
 *  @param strokeColor 弧线颜色
 */
-(void)drawArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle lineWidth:(CGFloat)lineWitdth fillColor:(UIColor*)filleColor strokeColor:(UIColor*)strokeColor{
    //保存弧线宽度,开始角度，结束角度
    self.lineWidth=lineWitdth;
    self.startAngle=startAngle;
    self.endAngle=endAngle;
    self.arcAngle=endAngle-startAngle;
    self.arcRadius=Calculate_radius;
    self.scaleRadius=self.arcRadius-self.lineWidth;
    self.scaleValueRadius=self.scaleRadius-self.lineWidth;
    //self.speedLabel.text=@"0%";
    
    
    UIBezierPath* outArc=[UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer* shapeLayer=[CAShapeLayer layer];
    shapeLayer.lineWidth=lineWitdth;
    shapeLayer.fillColor=filleColor.CGColor;
    shapeLayer.strokeColor=strokeColor.CGColor;
    shapeLayer.path=outArc.CGPath;
    shapeLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
}
/**
 *  画刻度
 *
 *  @param divide      刻度几等分
 *  @param remainder   刻度数
 *  @param strokeColor 轮廓填充颜色
 *  @param fillColor   刻度颜色
 */
//center:中心点，即圆心
//startAngle：起始角度
//endAngle：结束角度
//clockwise：是否逆时针
-(void)drawScaleWithDivide:(int)divide andRemainder:(NSInteger)remainder strokeColor:(UIColor*)strokeColor filleColor:(UIColor*)fillColor scaleLineNormalWidth:(CGFloat)scaleLineNormalWidth scaleLineBigWidth:(CGFloat)scaleLineBigWidth{
    
    CGFloat perAngle=self.arcAngle/divide;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (NSInteger i = 0; i<= divide; i++) {
        
        CGFloat startAngel = (self.startAngle+ perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.scaleRadius startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        
        if((remainder!=0)&&(i % remainder) == 0) {
            perLayer.strokeColor = strokeColor.CGColor;
            perLayer.lineWidth   = scaleLineBigWidth;
            
        }else{
            perLayer.strokeColor = strokeColor.CGColor;;
            perLayer.lineWidth   = scaleLineNormalWidth;
            
        }
        
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
        
    }
}
/**
 *  进度条曲线
 *
 *  @param fillColor   填充颜色
 *  @param strokeColor 轮廓颜色
 */
- (void)drawProgressCicrleWithfillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    self.progressLayer = progressLayer;
    progressLayer.lineWidth = self.lineWidth+0.25f;
    progressLayer.fillColor = fillColor.CGColor;
    progressLayer.strokeColor = strokeColor.CGColor;
    progressLayer.path = progressPath.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0.0;
    progressLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:progressLayer];
}

- (void)runSpeedProgress{
//    [self.speedLabel countFrom:0 to:_speedValue withDuration:1];
    [UIView animateWithDuration:1 animations:^{
        self.progressLayer.strokeEnd = 0.01 * _speedValue;
    }];
    
}
/**
 *  添加渐变图层
 *
 *  @param colorGradArray 颜色数组，如果想达到红-黄-红效果，数组应该是红，黄，红
 */
-(void)setColorGrad:(NSArray*)colorGradArray{
    //渐变图层
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    //增加渐变图层，frame为当前layer的frame
    gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [gradientLayer1 setColors:colorGradArray];
    [gradientLayer1 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
    [gradientLayer addSublayer:gradientLayer1];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}
-(void)setViewData:(id)viewData{
    if (![viewData isKindOfClass:[CRHRiskResultVo class]]) {
        return;
    }
    
    CRHRiskResultVo * VO = viewData;
    self.speedValue = [VO.paper_score integerValue];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(runSpeedProgress) userInfo:nil repeats:NO];
    self.typeLb.text = VO.risk_level_name;
    self.subTitle.text = @"风险承受能力";
}

@end

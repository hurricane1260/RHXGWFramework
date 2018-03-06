//
//  KSFrameView.m
//  MosiacCamera
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import "IDFrameView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCANLINE_SPEED 5
@interface IDFrameView()
{
    int LINE_LENGTH;
    int SCANLINE_WIDTH;
    int scan_num;
}
@property (nonatomic, strong) NSTimer *timer;
//扫描线
@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, strong) NSTimer *line_timer;
@end

@implementation IDFrameView
@synthesize promptLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        if (SCREEN_WIDTH - 320 < 1) {   //ip4, ip5
            SCANLINE_WIDTH = 14;
        } else {                        //ip6
            SCANLINE_WIDTH = 18;
        }
        LINE_LENGTH = frame.size.width / 10;
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
         self.timer = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        scan_num = 0;
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCANLINE_WIDTH, frame.size.width)];
        _line.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/scan_line_portrait.png"];
        _line.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_line];
        _line.transform = transform;
        _line.center = CGPointMake(frame.size.width/2, 0);
        self.line_timer = [NSTimer scheduledTimerWithTimeInterval:.03 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
        [self.line_timer fire];
        
        promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.textColor = [UIColor greenColor];
        promptLabel.font = [UIFont boldSystemFontOfSize:17];
        promptLabel.text = @"请将身份证放在屏幕中央，正面朝上";
        promptLabel.numberOfLines = 0;
        [self addSubview:promptLabel];
        promptLabel.transform = transform;
        float x = frame.size.width * 22 / 54;
        x = x + (frame.size.width - x) / 2;
        promptLabel.center = CGPointMake(frame.size.width-35, frame.size.height/2);


        self.headImage = [[UIImageView alloc]init];
        UIImage * image1 = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_idcard_background"];
        self.headImage.image = image1;
        self.headImage.size = CGSizeMake(image1.size.width, image1.size.height);
        [self addSubview:self.headImage];
        self.headImage.transform = transform;
        
        if (IS_IPHONE_5) {
            self.headImage.center = CGPointMake(frame.size.width-76-image1.size.height/2, frame.size.height-90-image1.size.width/2);
        }else{
            self.headImage.center = CGPointMake(frame.size.width-76-image1.size.height/2, frame.size.height-134-image1.size.width/2);
        }
        
        
        self.naEmblemImage = [[UIImageView alloc]init];
        UIImage * image2 = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_idcard_backgroundback"];
        self.naEmblemImage.image = image2;
        self.naEmblemImage.size = CGSizeMake(image2.size.width, image2.size.height);
        [self addSubview:self.naEmblemImage];
        self.naEmblemImage.transform = transform;
        if (IS_IPHONE_5) {
            self.naEmblemImage.center = CGPointMake(frame.size.width-67-image2.size.height/2, 60+image2.size.width/2);
        }else{
            self.naEmblemImage.center = CGPointMake(frame.size.width-67-image2.size.height/2, 92+image2.size.width/2);
        }
        
        
        

//        UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0,  0, frame.size.height, 50)];
//        labelT.backgroundColor = [UIColor clearColor];
//        labelT.textAlignment = NSTextAlignmentCenter;
//    
//        labelT.textColor = [UIColor lightGrayColor];
//        labelT.font = [UIFont boldSystemFontOfSize:15];
//        labelT.text = @"身份证识别技术由易道博识提供";
//        [self addSubview:labelT];
//        
//        
//        
//        CGAffineTransform Ttransform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
//        labelT.transform = Ttransform;
//
//        float Tx = frame.size.width * 22 / 54;
//        Tx = Tx + (frame.size.width - Tx) / 2;
//        labelT.center = CGPointMake(Tx - 240, frame.size.height/2);
        
//        float Tx = frame.size.width * 22 / 54;
//        Tx = Tx + (frame.size.width - Tx) / 2;
//        labelT.center = CGPointMake(Tx, frame.size.height/2);
    }
    return self;
}
-(void)dealloc{
    [self.timer invalidate];
    [self.line_timer invalidate];
}

-(void)lineAnimation
{
    //scan line
    scan_num ++;
    if (SCANLINE_SPEED*scan_num >= self.frame.size.height) {
        scan_num = 0;
    }
    _line.center = CGPointMake(self.frame.size.width/2, SCANLINE_SPEED*scan_num);
}

-(void)timerFire:(id)notice
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8.0);
    CGContextSetRGBStrokeColor(context, 0.3, 0.8, 0.3, 0.8);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y + LINE_LENGTH);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y - LINE_LENGTH);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + LINE_LENGTH, pt.y);
    
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x - LINE_LENGTH, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-LINE_LENGTH);
    CGContextStrokePath(context);

}

@end

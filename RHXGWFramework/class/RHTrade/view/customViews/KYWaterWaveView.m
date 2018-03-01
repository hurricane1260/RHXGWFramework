//
//  KYWaterWaveView.m
//  KYWaterWaveAnimation
//
//  Created by Kitten Yang on 3/16/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#define pathPadding 30

#import "KYWaterWaveView.h"



@interface KYWaterWaveView()<UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIImageView *fish;

@end

@implementation KYWaterWaveView{
    CALayer *l;
    
    BOOL fishFirstColl;
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    CAShapeLayer  *waveLayer;
    UIBezierPath *waveBoundaryPath;
    
    UICollisionBehavior *coll;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = frame.size.height / 2;
        waterWaveWidth  = frame.size.width;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        waterWaveHeight = self.frame.size.height / 2;
        waterWaveWidth  = self.frame.size.width;
        
    }
    return self;
}

#pragma mark - public
- (void)wave {
    waveBoundaryPath = [UIBezierPath bezierPath];
    
    waveLayer = [CAShapeLayer layer];
    waveLayer = [CAShapeLayer layer];
    if (_waveSpeed == 1) {
        waveLayer.fillColor = color5_text_xgw.CGColor;
    } else {
        waveLayer.fillColor = color2_text_xgw.CGColor;
    }
    [self.layer addSublayer:waveLayer];
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [waveDisplaylink invalidate];
    waveDisplaylink = nil;
}

#pragma mark - helper
- (void)getCurrentWave:(CADisplayLink *)displayLink {
    [coll removeAllBoundaries];
    offsetX += self.waveSpeed;
    waveBoundaryPath = [self getgetCurrentWavePath];
    waveLayer.path = waveBoundaryPath.CGPath;
    
    [coll addBoundaryWithIdentifier:@"waveBoundary" forPath:waveBoundaryPath];
}

- (UIBezierPath *)getgetCurrentWavePath {
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, waterWaveHeight);
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        y = self.waveAmplitude* sinf((360/waterWaveWidth) *(x * M_PI / 180) - offsetX * M_PI / 180) + waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}


@end

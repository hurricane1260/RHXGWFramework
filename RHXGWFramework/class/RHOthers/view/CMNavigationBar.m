//
//  CMNavigationBar.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-9.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "CMNavigationBar.h"

@implementation CMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colourAdjustFactor = 1;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.colourAdjustFactor = 1;
    }
    return self;
}
-(void)setColourAdjustFactor:(CGFloat)colourAdjustFactor{
    _colourAdjustFactor = colourAdjustFactor;
    [self setNeedsDisplay];
}

- (UIColor *)adjustColourBrightness:(UIColor *)color withFactor:(double)factor
{
    CGColorRef cgColour = [color CGColor];
    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(cgColour);
    CGFloat newComponents[4];
    
    size_t numComponents = CGColorGetNumberOfComponents(cgColour);
    
    
    switch (numComponents)
    {
        case 2:
        {
            //grayscale
            newComponents[0] = oldComponents[0]*factor;
            newComponents[1] = oldComponents[0]*factor;
            newComponents[2] = oldComponents[0]*factor;
            newComponents[3] = oldComponents[1];
            break;
        }
        case 4:
        {
            //RGBA
            newComponents[0] = oldComponents[0]*factor;
            newComponents[1] = oldComponents[1]*factor;
            newComponents[2] = oldComponents[2]*factor;
            newComponents[3] = oldComponents[3];
            break;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *retColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    
    return retColor;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.tintColor == nil){
        NSLog(@"UINavigationBarAdjustableTint: Didn't do anything because there is no tint colour set. Please set the tintColor property.");
        return; //dont do anything if we dont have a tint colour.
    }
    
    UIColor *bottomColor = self.tintColor;
    UIColor *topColor = [self adjustColourBrightness:bottomColor withFactor:self.colourAdjustFactor];
    
    
    // emulate the normal gradient tint
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray *colours = [NSArray arrayWithObjects:(__bridge id)topColor.CGColor, (__bridge id) bottomColor.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(myColorspace, (__bridge CFArrayRef)colours, locations);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height), 0);
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(myColorspace);
    
    // top Line 1 px high across the very top of the bar slightly lighter colour than the top gradient color
    CGContextSetStrokeColorWithColor(context, [[self adjustColourBrightness:topColor withFactor:1.5] CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextStrokePath(context);
    
    // bottom line 1px across the bottom of the bar in black
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    CGContextStrokePath(context);
}

@end

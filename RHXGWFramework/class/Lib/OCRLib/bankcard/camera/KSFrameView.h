//
//  KSFrameView.h
//  MosiacCamera
//
//  Created by wangchen on 4/2/15.
//  Copyright (c) 2015 kimsungwhee.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSFrameView : UIView

@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UILabel *supportLabel;

-(void)loadUI:(UIInterfaceOrientation)orientation;
@end

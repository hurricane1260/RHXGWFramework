//
//  CameraViewController__1.h
//  crh-sjkh
//
//  Created by milo on 14-7-18.
//  Copyright (c) 2014年 com.cairh. All rights reserved.
//
#import <UIKit/UIKit.h>
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@protocol ImageCropViewControllerDelegate;


@interface ImageCropViewController:UIViewController
@property(nonatomic,assign) id<ImageCropViewControllerDelegate> delegate;
@property(retain) UIImage *image;
@property(retain) UIImageView *imageView;
@property(retain) UIToolbar *toolbar;
-(IBAction)ok:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)left:(id)sender;
-(IBAction)right:(id)sender;
-(void)show:(UIViewController*)parent image:(UIImage*)image delegate:(id<ImageCropViewControllerDelegate>)delegate;
@end
@protocol ImageCropViewControllerDelegate <NSObject>

-(void)didFinishViewController:(id)sender cropImage:(UIImage*)cropImage;
-(void)didCancelViewController:(id)sender;

@end
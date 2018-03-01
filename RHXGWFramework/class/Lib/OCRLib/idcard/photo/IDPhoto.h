//
//  IDPhoto.h
//  EXOCR
//
//  Created by mac on 15/9/21.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IdInfo;
@protocol IDPhotoDelegate <NSObject>
-(void)returnIDPhotoResult:(IdInfo *)idInfo from:(id)sender;
-(void)didFinishPhotoRec;
@end

@interface IDPhoto : NSObject <UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property(nonatomic, retain)UIViewController *target;

-(void) photoReco;

@property (nonatomic, assign) id<IDPhotoDelegate> delegate;
@end

//
//  RHCameraController.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/10.
//
//

#import <UIKit/UIKit.h>

@class RHCameraController;
@protocol RHCameraControllerDelegate  <NSObject>

- (void)imageCameraController:(RHCameraController *)imgPicker didFinishPhotoInfo:(NSDictionary *)info;

@end

@interface RHCameraController : UIViewController

@end

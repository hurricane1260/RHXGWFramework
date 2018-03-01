//
//  RightTableCell.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/20.
//
//

#import <UIKit/UIKit.h>

@interface RightTableCell : UITableViewCell

+(NSString *)reuseIdentifier;
@property (nonatomic, strong) id cellData;

@end

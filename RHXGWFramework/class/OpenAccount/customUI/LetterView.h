//
//  LetterView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/12.
//
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    topLetterType = 1,//上面的信
    bottomLetterType,//下面的信
    
}LetterType;


@interface LetterView : UIView

@property (nonatomic,strong)id viewData;
-(instancetype)initWithParams:(NSDictionary *)params;

- (NSInteger)getCurrentHeight;

-(void)setMoneyman:(NSString *)moneyman andLetterType:(LetterType)type;

-(void)setViewDataWithModel:(id)model andClientName:(NSString *)name andLetterType:(LetterType)type;
@end

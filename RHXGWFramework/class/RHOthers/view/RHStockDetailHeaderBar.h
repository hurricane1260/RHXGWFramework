//
//  RHStockDetailHeaderBar.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/8/25.
//
//

#import "CMHeaderBar.h"

typedef enum :NSInteger{
    pointBubble = 1,
    labelBubble,
}BubbleType;

@interface RHStockDetailHeaderBar : CMHeaderBar

@property (nonatomic, assign) BOOL showNews;
@property (nonatomic, assign) BOOL showReport;
@property (nonatomic, assign) BOOL showNotice;

kRhPStrong id bubbleData;

kRhPAssign BubbleType bubType;

- (id)initWithTitleList:(NSDictionary *)titleToOrderFieldMap titleList:(NSArray *)aList titleColor:(UIColor *)aColor highlightedColor:(UIColor *)bColor titleFontSize:(CGFloat)aSize delegate:(id<CMHeaderBarDelegate>)aDelegate withBubbleType:(BubbleType)butType;

@end

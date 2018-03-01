//
//  RHStockDetailHeaderBar.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/8/25.
//
//

#import "RHStockDetailHeaderBar.h"

@interface RHStockDetailHeaderBar ()

@property (nonatomic, strong) NSMutableArray *bubbleItems;

@end

@implementation RHStockDetailHeaderBar

-(void)didBuildBarItems{
    
    
    [super didBuildBarItems];
    self.bottomLine.backgroundColor = self.titleHighlightedColor;
    
//    NSString * title = self.titleList[0];
//    CGSize size = [title sizeWithAttributes:self.titleAttributeFont];
//    [self.bottomLine setWidth:size.width];
////    self.bottomLine.center = MAIN_SCREEN_WIDTH /self.titleList.count 
    self.bubbleItems = [NSMutableArray array];
    if (!self.bubType) {
        return;
    }
    switch (self.bubType) {
        case pointBubble:
        {
            for (int i = 0; i < 3; i++) {
                UIView * bubbleView = [[UIView alloc] init];
                bubbleView.width = 5.0f;
                bubbleView.height = 5.0f;
                bubbleView.backgroundColor = color6_text_xgw;
                bubbleView.layer.cornerRadius = 2.5f;
                bubbleView.clipsToBounds = YES;
                bubbleView.hidden = YES;
                [self addSubview:bubbleView];
                [self.bubbleItems addObject:bubbleView];
            }
            break;
        }
        case labelBubble:
        {
            for (int i = 0; i < 3; i++) {
//                UILabel * bubbleLabel = [UILabel didBuildLabelWithText:@"" fontSize:12.0f textColor:color1_text_xgw wordWrap:NO];
                UILabel * bubbleLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color1_text_xgw wordWrap:NO];
                bubbleLabel.backgroundColor = color6_text_xgw;
                bubbleLabel.textAlignment = NSTextAlignmentCenter;
                bubbleLabel.hidden = YES;
                [self addSubview:bubbleLabel];
                [self.bubbleItems addObject:bubbleLabel];
            }
            break;
        }
        default:
            break;
    }
}

-(void)setBubType:(BubbleType)bubType{
    _bubType = bubType;
    [self didBuildBarItems];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat avgWidth = self.width / self.titleList.count;
//    CGFloat x = avgWidth * 2.0 - 1.0/4.0f * avgWidth;
    switch (self.bubType) {
        case pointBubble:
        {
            CGFloat x = avgWidth * 2.0 - 1.0/4.0f * avgWidth;
            for (UIView * bubble in self.bubbleItems) {
                bubble.x = x;
                bubble.y = 10.0f;
                x += avgWidth;
            }
            break;
        }
        case labelBubble:
        {
            CGFloat x = avgWidth - 1.0/4.0f * avgWidth;
            for (UILabel * bubble in self.bubbleItems) {
                [bubble sizeToFit];
                bubble.width = bubble.width + 12.0f;
                bubble.layer.cornerRadius = bubble.height /2.0f;
                bubble.clipsToBounds = YES;
                bubble.x = x;
                bubble.y = 5.0f;
                x += avgWidth;
            }
            break;
        }
        default:
            break;
    }
    
}
//1
- (void)setShowNews:(BOOL)showNews{
    _showNews = showNews;
    UIView * bubble = self.bubbleItems[0];
    bubble.hidden = !showNews;
}
//2
- (void)setShowReport:(BOOL)showReport{
    _showReport = showReport;
    UIView * bubble = self.bubbleItems[1];
    bubble.hidden = !showReport;
}
//3
- (void)setShowNotice:(BOOL)showNotice{
    _showNotice = showNotice;
    UIView * bubble = self.bubbleItems[2];
    bubble.hidden = !showNotice;
}

- (void)setBubbleData:(id)bubbleData{
    if (!bubbleData || ![bubbleData isKindOfClass:[NSArray class]]) {
        return;
    }
    if (self.bubType == labelBubble) {
        NSArray * bubbleArr = (NSArray *)bubbleData;
        for (int i = 0; i < bubbleArr.count; i++) {
            NSNumber * num = bubbleArr[i];
            NSString * numStr;
            if ([num integerValue] > 99) {
                numStr = @"...";
            }
            else{
                numStr = [NSString stringWithFormat:@"%@",num];
            }
            UILabel * bubble = self.bubbleItems[i];
            bubble.text = numStr;
        }
        [self setNeedsLayout];
    }
}

@end

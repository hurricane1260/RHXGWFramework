//
//  RevisitCell.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import "RevisitCell.h"
#import "RevisitChooseView.h"
#import "CRHRiskTestVo.h"
#import "ForumLayoutManager.h"

@interface RevisitCell ()
@property (nonatomic,strong) UILabel * questionLabel;
@property (nonatomic,strong) RevisitChooseView * revisitChooseView;
kRhPStrong CRHRiskTestVo * testVo;
//答案选项的数组
kRhPStrong NSMutableArray * answerArr;
//默认选中的数组
kRhPStrong NSMutableArray * answerSelect;
kRhPStrong NSMutableArray * viewArr;
kRhPAssign BOOL isChoosed;
kRhPStrong RevisitChooseView * cView;



@end

@implementation RevisitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.answerArr = [NSMutableArray array];
        self.viewArr = [NSMutableArray array];
        self.answerSelect = [NSMutableArray array];
        [self initSubViews];
    }
    return self;
    
}
-(void)initSubViews{

    self.questionLabel = [UILabel didBuildLabelWithText:@"" font:font2_boldCommon_xgw textColor:color2_text_xgw wordWrap:YES];
    self.questionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.questionLabel];
    
   
    
}

-(void)creatRevisitChooseView{
    __weak typeof(self) welf = self;
    if (self.viewArr.count!=0) {
        [self.viewArr removeAllObjects];
        [self.cView removeFromSuperview];
    }
    for (int i = 0; i < self.answerArr.count; i++) {
        
        self.cView = [[RevisitChooseView alloc] initWithContent:self.answerArr[i] andDefaultSelet:self.answerSelect[i]];
        __weak typeof(self.cView) wcView = self.cView;
        self.cView.selectCallBack = ^(NSDictionary * param){
            
            if ([param objectForKey:@"select"]) {
                welf.isChoosed = [[param objectForKey:@"select"] boolValue];
                //是否是默认选中的
                if (!welf.isChoosed) {
                    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                    if ([NSString isBlankString:welf.testVo.warn_tip]) {
                        [param setValue:@"根据您的选择,我们无法为您办理开户业务" forKey:@"warn"];
                        
                    }else{
                        [param setValue:welf.testVo.warn_tip forKey:@"warn"];
                    }
                    if (welf.warnBlock) {
                        welf.warnBlock(param);
                    }
                }
            }
            
        };
        
        self.cView.widthCallBack = ^(NSDictionary * param){
            if ([param objectForKey:@"width"]&&[param objectForKey:@"height"]) {
                wcView.width = [[param objectForKey:@"width"] floatValue];
                wcView.height = [[param objectForKey:@"height"] floatValue];
                
                [welf setNeedsLayout];
            }
        };
        [self.contentView addSubview:self.cView];
        [self.viewArr addObject:self.cView];
    }
    

    
    
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    //增加文本间距
    
    CGSize size = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f fontsize:14 content:self.questionLabel.text space:4];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.questionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.questionLabel.text length])];
    self.questionLabel.attributedText = attributedString;
    
    self.questionLabel.frame = CGRectMake(24.0f, 0, size.width, size.height);
    
    
    CGFloat offsetY = CGRectGetMaxY(self.questionLabel.frame) + 20.0f;
    CGFloat offsetX = 24;
    
    for (int i = 0; i < self.viewArr.count; i++) {
        RevisitChooseView * cView = self.viewArr[i];
        cView.frame = CGRectMake(offsetX, offsetY,cView.width ,cView.height);
        offsetX += cView.width + 30.0f;
        
    }
    
    self.revisitChooseView.frame = CGRectMake(24, CGRectGetMaxY(self.questionLabel.frame)+20, kDeviceWidth, 20);
    
}
- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row{
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    self.testVo = model;
    
    
    NSDictionary * answer = self.testVo.answer_content;
    NSArray * keys = answer.allKeys;
    if (self.answerArr.count!=0) {
        [self.answerArr removeAllObjects];
    }
    for (int i = 0; i < answer.count; i++) {
        [self.answerArr addObject:[answer objectForKey:keys[i]]];
        if ([keys[i] isEqualToString:self.testVo.default_answer]) {
            [self.answerSelect addObject:@1];
        }else{
            [self.answerSelect addObject:@0];

        }
    }
    self.questionLabel.text = [NSString stringWithFormat:@"%ld.%@",(long)row+1,self.testVo.question_content];
    [self creatRevisitChooseView];
    [self setNeedsLayout];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

//
//  RiskTestCell.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/3.
//
//

#import "RiskTestCell.h"
#import "CRHRiskTestVo.h"
#import "ChooseView.h"
#import "ForumLayoutManager.h"

@interface RiskTestCell ()

kRhPStrong UILabel * questionLabel;

//kRhPStrong TTTAttributedLabel * chooseLabel;

kRhPStrong NSMutableArray * answerArr;

kRhPStrong NSMutableArray * viewArr;

kRhPAssign BOOL isChoosed;

kRhPStrong CRHRiskTestVo * testVo;
kRhPAssign NSInteger index;
kRhPStrong ChooseView * cView;
kRhPStrong NSMutableArray * MuArray;
@end

@implementation RiskTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)  reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.answerArr = [NSMutableArray array];
        self.viewArr = [NSMutableArray array];
        self.MuArray = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}



- (void)initSubviews{

    self.questionLabel = [UILabel didBuildLabelWithText:@"" font:font2_boldCommon_xgw textColor:color2_text_xgw wordWrap:YES];
    self.questionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.questionLabel];
    
}



-(void)creatRevisitChooseView{
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.contentView addSubview:self.questionLabel];


    __weak typeof(self) welf = self;
    
    if (self.viewArr.count!=0) {
        [self.viewArr removeAllObjects];
    }
    
    for (int i = 0; i < self.answerArr.count; i++) {
        
        self.cView = [[ChooseView alloc] initWithContent:self.answerArr[i]];
        __weak typeof(self.cView) wcView = self.cView;
        self.cView.tag = 1000+i;
        self.cView.selectCallBack = ^(NSDictionary * param){
            
            
            ChooseView * selectBtnView = [param objectForKey:@"seleBtnView"];
            if ([param objectForKey:@"select"]) {
                welf.isChoosed = [[param objectForKey:@"select"] boolValue];
                
            }
            NSMutableDictionary * questionDic = [NSMutableDictionary dictionary];
            
            if ([welf.testVo.question_kind isEqualToString:@"1"]) {
                //多选
                selectBtnView.isSelected = welf.isChoosed;
                NSString * questionNum = welf.testVo.question_no;
                NSString * answerNum = [NSString stringWithFormat:@"%ld",selectBtnView.tag-1000+1];
                
                if (welf.isChoosed) {
                    //选中
                    [welf.MuArray addObject:answerNum];
                    [questionDic setObject:welf.MuArray forKey:questionNum];
                    
                }else{
                    //取消选中
                    [welf.MuArray removeObject:answerNum];
                    
                    [questionDic setObject:welf.MuArray forKey:questionNum];
                    
                }

            }else if ([welf.testVo.question_kind isEqualToString:@"0"]){
                //单选
                NSString * questionNum = welf.testVo.question_no;//题号
                NSString * questionContent = welf.testVo.question_content;
                
//                if ([riskTestVO.question_content rangeOfString:@"您的年龄是"].location!= NSNotFound ){
//                    [params setValue:[NSArray arrayWithObject:age] forKey:riskTestVO.question_no];
//
//                }else if ([riskTestVO.question_content rangeOfString:@"您的最高学历是"].location!= NSNotFound){
//                    [params setValue:[NSArray arrayWithObject:education] forKey:riskTestVO.question_no];
//
//                }
                
                
                if ([questionContent rangeOfString:@"您的年龄是"].location!= NSNotFound) {
                    if (welf.promptBlock) {
                        welf.promptBlock(AgeType);
                    }
                    return ;
                }
                    if ([questionContent rangeOfString:@"您的最高学历是"].location!= NSNotFound) {
                        
                      if (welf.promptBlock) {
                        welf.promptBlock(EducationType);
                    }
                    return ;

                   
                }
                
                for (int i =0; i < self.answerArr.count; i++) {
                    ChooseView * chView = (ChooseView *)[welf viewWithTag:1000+i];
                    chView.isSelected = NO;
                }
                selectBtnView.isSelected = YES;
                NSString * answerNum = [NSString stringWithFormat:@"%ld",selectBtnView.tag-1000+1];
                NSMutableArray * questionNumArray = [NSMutableArray arrayWithObject:answerNum];
                [questionDic setObject:questionNumArray forKey:questionNum];
                
            }
            
            if (welf.riskTestBlock) {
                welf.riskTestBlock(questionDic);
            }

            if (welf.automaticJump) {
                welf.automaticJump([NSString stringWithFormat:@"%ld",(long)welf.index],welf.testVo.question_kind);
                
            }
            
        };
        
        self.cView.heightCallBack = ^(NSDictionary * param){
            if ([param objectForKey:@"height"]) {
                wcView.height = [[param objectForKey:@"height"] floatValue];
                [welf setNeedsLayout];
            }
        };
        [self.contentView addSubview:self.cView];
        [self.viewArr addObject:self.cView];
    }

}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f fontsize:14 content:[NSString stringWithFormat:@"%@请如实回答",self.questionLabel.text] space:4];

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.questionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.questionLabel.text length])];
    
    if ([self.testVo.question_content rangeOfString:@"您的主要收入来源是"].location!= NSNotFound ||[self.testVo.question_content rangeOfString:@"以下描述中何种符合您的实际情况"].location!= NSNotFound ||[self.testVo.question_content rangeOfString:@"您的投资经验可以被概括为"].location!= NSNotFound ||[self.testVo.question_content rangeOfString:@"您投资经验在两年以上的有"].location!= NSNotFound ||[self.testVo.question_content rangeOfString:@"您家庭的就业状况是"].location!= NSNotFound) {
        
        
        // 2.添加表情图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        UIImage * image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/img_question_survey"];
        attch.image = image;
        // 设置图片大小
        attch.bounds = CGRectMake(0, -3, image.size.width, image.size.height);
        
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attributedString insertAttributedString:string atIndex:self.questionLabel.text.length];// 插入某个位置
        
        
    }
    // 用label的attributedText属性来使用富文本
    self.questionLabel.attributedText = attributedString;
    
    self.questionLabel.frame = CGRectMake(24.0f, 0, size.width, size.height);
    
    CGFloat offsetY = CGRectGetMaxY(self.questionLabel.frame) + 20.0f;
    
    for (int i = 0; i < self.viewArr.count; i++) {
        ChooseView * cView = self.viewArr[i];
        cView.frame = CGRectMake(0, offsetY, self.width, cView.height);
        offsetY += cView.height + 16.0f;
   
    }
}

#pragma 获取不带任何默认选择的的风险测评试卷
- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row{
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    self.testVo = model;
    self.index = row;
    
   // NSDictionary * answer = [self dictionaryWithJsonString:self.testVo.answer_content];
    
    NSDictionary * answer = self.testVo.answer_content;
    if (self.answerArr.count!=0) {
        [self.answerArr removeAllObjects];
    }
    for (int i = 0; i < answer.count; i++) {
        [self.answerArr addObject:[answer objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
    }
    NSMutableString * str = [[NSMutableString alloc]initWithString:self.testVo.question_content];
//判断单选还是多选
    if ([self.testVo.question_kind isEqualToString:@"1"]) {
        
        [str insertString:@"(多选)" atIndex:str.length];
      self.questionLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)row+1,str];
        
        
    }else if ([self.testVo.question_kind isEqualToString:@"0"]){
        
        
        [str insertString:@"(单选)" atIndex:str.length];
        self.questionLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)row+1,str];
    }
    
    [self creatRevisitChooseView];
    [self setNeedsLayout];
}



#pragma 给风险测评试题赋值  在用户已经测评过得的情况（被退回的情况）
-(void)setDefaultSelectWithModel:(id)model defaultResultDic:(NSDictionary *)defaultResultDic{
    
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    self.testVo = model;
    NSDictionary * answerDic = self.testVo.answer_content;//答案内容
    NSString * questionNum = self.testVo.question_no;//题号
    NSArray * defaultArray =defaultResultDic[questionNum];
    if (defaultArray.count==0) {
        return;
    }
 
    for (int i =0 ; i < answerDic.count; i++) {
        for (int j = 0; j < defaultArray.count;j++ ) {
            
            if ([[NSString stringWithFormat:@"%d",i+1] isEqualToString:defaultArray[j]]) {
                ChooseView * chView = (ChooseView *)[self viewWithTag:1000+i];
                chView.isSelected = YES;
                
                if ([self.testVo.question_kind isEqualToString:@"1"]) {
                    
                    [self.MuArray addObject:defaultArray[j]];
                    
                }
        }

        }
        
    }
   
    NSMutableDictionary * questionDic = [NSMutableDictionary dictionary];
    [questionDic setObject:defaultArray forKey:questionNum];
        
        
    if (self.riskTestBlock) {
        self.riskTestBlock(questionDic);
    }
    [self setNeedsLayout];

}
#pragma 给用户的年龄和学历默认选择
- (void)setAgeEducationWithModel:(id)model  AgeEducationDic:(NSDictionary *)ageEducationDic{
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    
    self.testVo = model;
    NSDictionary * answerDic = self.testVo.answer_content;//答案内容
    NSString * questionNum = self.testVo.question_no;//题号
    NSArray * ageEducationArray =ageEducationDic[questionNum];
    if (ageEducationArray.count==0) {
        return;
    }
    
    for (int i =0 ; i < answerDic.count; i++) {
             ChooseView * chView = (ChooseView *)[self viewWithTag:1000+i];
             chView.isSelected = NO;
        for (int j = 0; j < ageEducationArray.count;j++ ) {
            if ([[NSString stringWithFormat:@"%d",i+1] isEqualToString:ageEducationArray[j]]) {
                ChooseView * chView = (ChooseView *)[self viewWithTag:1000+i];
                chView.isSelected = YES;
                    
                }
            }
            
        }
        
    NSMutableDictionary * questionDic = [NSMutableDictionary dictionary];
    [questionDic setObject:ageEducationArray forKey:questionNum];
    
    
    if (self.riskTestBlock) {
        self.riskTestBlock(questionDic);
    }
    [self setNeedsLayout];

    
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark--这个方法暂时没有用
-(void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row defaultResultDic:(NSDictionary *)defaultResultDic{
    
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    self.testVo = model;
    self.index = row;
    
    // NSDictionary * answer = [self dictionaryWithJsonString:self.testVo.answer_content];
    
    NSDictionary * answer = self.testVo.answer_content;
    if (self.answerArr.count!=0) {
        [self.answerArr removeAllObjects];
    }
    for (int i = 0; i < answer.count; i++) {
        [self.answerArr addObject:[answer objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
    }
    NSMutableString * str = [[NSMutableString alloc]initWithString:self.testVo.question_content];
    //判断单选还是多选
    if ([self.testVo.question_kind isEqualToString:@"1"]) {
        
        [str insertString:@"(多选题)" atIndex:str.length];
        self.questionLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)row+1,str];
        
        
    }else if ([self.testVo.question_kind isEqualToString:@"0"]){
        
        
        [str insertString:@"(单选题)" atIndex:str.length];
        self.questionLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)row+1,str];
    }
    
    [self creatRevisitChooseView];
    
    if (!model || ![model isKindOfClass:[CRHRiskTestVo class]]) {
        return;
    }
    self.testVo = model;
    NSDictionary * answerDic = self.testVo.answer_content;//答案内容
    NSString * questionNum = self.testVo.question_no;//题号
    NSArray * defaultArray =defaultResultDic[questionNum];
    if (defaultArray.count==0) {
        return;
    }
    
    for (int i =0 ; i < answerDic.count; i++) {
        for (int j = 0; j < defaultArray.count;j++ ) {
            
            if ([[NSString stringWithFormat:@"%d",i+1] isEqualToString:defaultArray[j]]) {
                ChooseView * chView = (ChooseView *)[self viewWithTag:1000+i];
                chView.isSelected = YES;
                
                if ([self.testVo.question_kind isEqualToString:@"1"]) {
                    
                    [self.MuArray addObject:defaultArray[j]];
                    
                }
            }
            
        }
        
    }
    
    NSMutableDictionary * questionDic = [NSMutableDictionary dictionary];
    [questionDic setObject:defaultArray forKey:questionNum];
    
    
    if (self.riskTestBlock) {
        self.riskTestBlock(questionDic);
    }
    
    
    
    [self setNeedsLayout];
    
    
}

@end

//
//  RiskTableViewDataSource.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/5.
//
//

#import "RiskTableViewDataSource.h"
#import "CRHRiskTestVo.h"
#import "ForumLayoutManager.h"
@interface RiskTableViewDataSource ()
@property (nonatomic,assign)CGFloat cellH;
@end


@implementation RiskTableViewDataSource
-(NSMutableArray *)rishQuestionsArray{
    if (!_rishQuestionsArray) {
        _rishQuestionsArray = [NSMutableArray array];
    }
    return _rishQuestionsArray;
}
-(NSMutableDictionary *)riskTestDic{
    if (!_riskTestDic) {
        _riskTestDic = [NSMutableDictionary dictionary];
    }
    
    return _riskTestDic;
}
-(NSMutableDictionary *)defaultResultDic{
    if (!_defaultResultDic) {
        
        _defaultResultDic = [NSMutableDictionary dictionary];
    }
    return _defaultResultDic;
}
-(NSMutableDictionary *)ageEducationDic{
    
    if (!_ageEducationDic) {
        
        _ageEducationDic = [NSMutableDictionary dictionary];
    }
    return _ageEducationDic;
}
-(NSMutableDictionary *)cellHeightDic{
    
    if (!_cellHeightDic) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.rishQuestionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) welf = self;
    RiskTestCell * riskCell = [tableView dequeueReusableCellWithIdentifier:@"RiskTestCell"];
    if (!riskCell) {
        riskCell = [[RiskTestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RiskTestCell"];
    }

    
    if (self.rishQuestionsArray.count !=0) {
        
    if (self.paperType == BlankType) {
        //空白试卷的数据
        [riskCell loadDataWithModel:self.rishQuestionsArray[indexPath.row] withIndexPath:indexPath.row];
        
    }else if (self.paperType == AllType){
        //用户提交过试卷的答案
        [riskCell setDefaultSelectWithModel:self.rishQuestionsArray[indexPath.row] defaultResultDic:self.defaultResultDic];
        
    }else if (self.paperType == ageAndEducationType){
        //默认填充年龄和学历
        [riskCell setAgeEducationWithModel:self.rishQuestionsArray[indexPath.row]  AgeEducationDic:self.ageEducationDic];
    }
        
    }
    
    riskCell.selectionStyle = UITableViewCellSelectionStyleNone;
    riskCell.riskTestBlock = ^(NSDictionary *params) {
       
            NSString * key = params.allKeys[0];
            NSArray * array = params[key];
         if (array.count==0) {
             if ([welf.riskTestDic.allKeys containsObject:key]) {
                 
                 [welf.riskTestDic removeObjectForKey:key];
             }
             
         }else{
             [welf.riskTestDic addEntriesFromDictionary:params];

         }
        
        if (welf.riskTestNextBlock) {
            welf.riskTestNextBlock(welf.riskTestDic);
        }
    };
    
    riskCell.promptBlock = ^(ChooseType type) {
        welf.warnBlock(type);
    };
    
    riskCell.automaticJump = ^(NSString *subjectIndex,NSString * type) {
        if (welf.automaticSubjectJump) {
            welf.automaticSubjectJump(subjectIndex,type);
        }
    };
    
    return riskCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRHRiskTestVo * testVo = self.rishQuestionsArray[indexPath.row];
    
    //因为cell中有对testVo.question_content的处理 拼接了 题号1、和 (多选题)和(单选题)所以这里计算高度时也要加上。
    
    NSMutableString * str = [[NSMutableString alloc]initWithString:testVo.question_content];
    [str insertString:@"(多选)请如实回答" atIndex:str.length];
    NSString * content = [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row+1,str];

    CGFloat questionH = [ForumLayoutManager autoCalculateWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f fontsize:14 content:content space:4.0];
    //20为间隙
    questionH = questionH+20;
    
    NSDictionary * answerDic = testVo.answer_content;
    NSMutableArray *answerArry =[NSMutableArray array];
    
    for (int i = 0; i < answerDic.count; i++) {
        [answerArry addObject:[answerDic objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
    }
    CGFloat H;
    CGFloat answerContentH = 0.0;
    for (NSString * content in answerArry) {
        H = [ForumLayoutManager autoCalculateWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f-16-10 fontsize:14 content:content space:3.0];
      //16为间隙
        H = H+16;
        answerContentH +=H;
    }
    CGFloat cellHeight = questionH+answerContentH;
    
    [self.cellHeightDic setValue:[NSString stringWithFormat:@"%f",cellHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end

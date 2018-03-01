//
//  RevisitTableDataSource.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import "RevisitTableDataSource.h"
#import "RevisitCell.h"
#import "ForumLayoutManager.h"
#import "CRHRiskTestVo.h"

@implementation RevisitTableDataSource
-(NSMutableArray *)rishQuestionsArray{
    if (!_rishQuestionsArray) {
        _rishQuestionsArray = [NSMutableArray array];
    }
    return _rishQuestionsArray;
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
    RevisitCell * revisitCell = [tableView dequeueReusableCellWithIdentifier:@"RevisitCell"];
    if (!revisitCell) {
        revisitCell = [[RevisitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RevisitCell"];
    }
    if (self.rishQuestionsArray.count!=0) {
        [revisitCell loadDataWithModel:self.rishQuestionsArray[indexPath.row] withIndexPath:indexPath.row];
    }
    revisitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    revisitCell.warnBlock = ^(NSDictionary *params) {
        if (welf.warnTipBlock) {
            welf.warnTipBlock(params);
        }
    };
    
    return revisitCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CRHRiskTestVo * testVo = self.rishQuestionsArray[indexPath.row];
    
    //因为cell中有对testVo.question_content的处理 拼接了 题号1、所以这里计算高度时也要加上。
    
    NSString * content = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row+1,testVo.question_content];
    
    CGFloat questionH = [ForumLayoutManager autoCalculateWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f fontsize:14 content:content space:4.0];
    //20为间隙
    questionH = questionH+20;
       
    return questionH+34;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

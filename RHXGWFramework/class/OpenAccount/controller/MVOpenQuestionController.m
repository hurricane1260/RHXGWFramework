//
//  MVOpenQuestionController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/21.
//
//

#import "MVOpenQuestionController.h"
#import "RHCustomTableView.h"
#import "MVOpenQuestionVo.h"
#import "MVOpenQuestionDataSource.h"

@interface MVOpenQuestionController ()

kRhPStrong RHCustomTableView * tableview;

kRhPStrong NSMutableArray * sourceArr;

kRhPStrong UILabel * headLabel;

kRhPStrong MVOpenQuestionDataSource * dataSource;
@end

@implementation MVOpenQuestionController

- (instancetype)init{
    if (self = [super init]) {
        
        self.title = @"常见开户问题";
        self.sourceArr = [NSMutableArray array];
        
        [self initSubviews];
    }
    return self;
}

- (void)getSourceData{
    NSArray * quesArr = @[@"1.开户都需要准备哪些材料?",@"2.手机开户对网络有什么要求？",@"3.手机开户为什么要上传身份证照?",@"4.手机开户为什么要进行视频见证?",@"5.手机开户视频见证等候时间过长怎么办?",@"6.视频认证时听不到声音或看不到人怎么回事?",@"7.进行开户时手机号或资料不能修改怎么办?",@"8.怎么知道我的账户是否开通?",@"9.我的手机会收到广告吗?",@"10.后续业务可否在异地办理？"];
    NSArray * answArr = @[@"（1）本人有效期内的二代身份证原件（须年满18周岁，以身份证出生日期为准）\n（2）本人手机\n（3）本人银行借记卡\n支持的银行包括：\n工商银行、光大银行、广发银行、建设银行、交通银行、民生银行、宁波银行、农业银行、平安银行、浦发银行、上海银行、兴业银行、邮政储蓄银行、招商银行、中国银行、中信银行。",@"建议使用4G、Wi-Fi的环境下进行手机开户。",@"根据监管机构要求，上传身份证照和个人相片是为核实投资者个人身份。",@"视频见证是为确保您的资产安全，根据监管机构要求，投资者网上开立中国登记公司股东账户还必须和证券公司网上开户见证人员通过网上视频进行实时视频见证，见证过程中见证人员将对您上传的证件资料和视频内容进行审核，并对见证视频进行录像。视频见证必须由您本人亲自办理。",@"在您准备视频见证前，请先检查您的网络保持通畅，周边环境安静，光线充足，建议使用耳机对话，如若排队人数过多，请选择非高峰期（上午）完成开户事项。另因网络和系统原因，有可能导致视频见证排队中出现插队等异常情况，请耐心等待。",@"视频认证时，若无法听到客服声音，1.可能是手机声音未打开；2.可能是未开通APP声音或相机权限，请在手机“设置”里找到“智能选股”APP权限打开“声音”或”麦克风“、打开”相机“或”摄像头“。",@"若想更改，请将所有资料提交完成，待返回结果：\n（1）开户失败的用户可以重新填写所有开户资料；\n（2）开户成功的用户，请联系华创证券客服400-0885-558。",@"开户结果以短信方式发送至您开户时填写的手机号码上。",@"除了必要的通知信息，不会给您发送任何广告信息。",@"可以，我司实现柜台业务通柜办理。可以委托我司在全国范围内的任何一个营业机构一站式办理账户权限业务申请、产品购买、资料更新业务。"];

    for (int i = 0; i < quesArr.count; i++) {
        MVOpenQuestionVo * vo = [[MVOpenQuestionVo alloc] init];
        vo.question = quesArr[i];
        vo.answer = answArr[i];
        [self.sourceArr addObject:vo];
    }
    
    [self.tableview reloadData];
}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;
    self.tableview = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.tabDataSource = self.dataSource;
    [self.tableview loadSettingWithDataList:self.sourceArr withHeight:50.0f withGapHeight:0 withCellName:@"OpenQuestionCell" withCellID:@"openQuestionCellID"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableview.heightCallBack = ^(NSDictionary * param){
//        if ([param objectForKey:@"height"]) {
//            welf.tableview.height = [[param objectForKey:@"height"] floatValue];
//            [welf.view setNeedsLayout];
//        }
//    };
    [self.view addSubview:self.tableview];
    
}

- (MVOpenQuestionDataSource *)dataSource{
    __weak typeof(self) welf = self;

    if (!_dataSource) {
        _dataSource = [[MVOpenQuestionDataSource alloc] init];
        _dataSource.reloadCallBack = ^{
        
            [welf.tableview reloadData];
            [welf.view setNeedsLayout];
        };
    }
    return _dataSource;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat tabHeight = 0.0f;
    NSArray * arr = [self.dataSource.indexDic allValues];
    for (NSNumber * h in arr) {
        tabHeight += [h floatValue];
    }
    self.tableview.contentSize = CGSizeMake(self.view.width, tabHeight);
    self.tableview.frame = CGRectMake(0, self.layoutStartY , self.view.width, self.view.height - self.layoutStartY);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getSourceData];

}

@end

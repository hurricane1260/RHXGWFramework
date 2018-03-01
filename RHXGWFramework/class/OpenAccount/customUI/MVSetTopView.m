//
//  MVSetTopView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/21.
//
//

#import "MVSetTopView.h"
#import "RHCustomTableView.h"
#import "MVSettingVo.h"

@interface MVSetTopView ()<RHBaseTableViewDelegate>

kRhPStrong RHCustomTableView * setTableView;

kRhPStrong UIImageView * img;

kRhPStrong NSMutableArray * sourceArr;

kRhPStrong UIView * backView;

@end

@implementation MVSetTopView

- (instancetype)init{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        self.sourceArr = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenClick)];
    [self.backView addGestureRecognizer:tap];
    [self addSubview:self.backView];
    
    self.img = [[UIImageView alloc] initWithImage:img_open_triangle];
    [self addSubview:self.img];
    
    NSArray * imgArr = @[img_open_trash,img_open_tel,img_open_question];
    NSArray * titleArr = @[@"清理用户缓存",@"400-088-5558",@"常见开户问题"];
    for (int i = 0; i < imgArr.count; i++) {
        MVSettingVo * vo = [[MVSettingVo alloc] init];
        vo.img = imgArr[i];
        vo.title = titleArr[i];
        [self.sourceArr addObject:vo];
    }
    self.setTableView = [[RHCustomTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.setTableView.customDelegate = self;
    self.setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.setTableView loadSettingWithDataList:self.sourceArr withHeight:50.0f withGapHeight:0.1f withCellName:@"MVSettingCell" withCellID:@"setCellID"];
    [self addSubview:self.setTableView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.frame = self.frame;
    
    self.img.frame = CGRectMake(self.width - 28.0f, 60.0 + 7.0f, self.img.width, self.img.height);
    
    self.setTableView.frame = CGRectMake(self.width - 7.0f - 138.0f, CGRectGetMaxY(self.img.frame) - 2.0f, 138.0f, 150.0f);
}

-(void)didSelectWithIndexPath:(id)data{
    if (!data || ![data isKindOfClass:[NSIndexPath class]]) {
        return;
    }
    NSIndexPath * indexPath = (NSIndexPath *)data;
    if (self.clickCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"row"];
        self.clickCallBack(param);
    }
}

- (void)hiddenClick{
    if (self.clickCallBack) {
        self.clickCallBack(nil);
    }

}

@end

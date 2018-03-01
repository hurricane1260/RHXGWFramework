//
//  TradeDirectionPickerView.m
//  stockscontest
//
//  Created by rxhui on 15/7/16.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeDirectionPickerView.h"

@interface TradeDirectionPickerView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *titleButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIControl *maskView;

@end

@implementation TradeDirectionPickerView

static NSString *cellID = @"directionListCellID";

- (instancetype)initWithTitleList:(NSArray *)titleList
{
    self = [super init];
    if (self) {
        [self initSubviews];
        self.titleList = titleList;
    }
    return self;
}

- (void)initSubviews {
    self.titleButton = [[UIButton alloc]init];
    [self addSubview:self.titleButton];
    self.titleButton.backgroundColor = [UIColor clearColor];
    [self.titleButton addTarget:self action:@selector(titleButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.titleButton addSubview:self.titleLabel];
    self.titleLabel.textColor = color2_text_xgw;
    self.titleLabel.font = font3_common_xgw;
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_mrmc_sjx"]];
    [self.titleButton addSubview:self.imageView];
    
    self.tableView = [[UITableView alloc]init];
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.maskView = [[UIControl alloc]init];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    self.maskView.hidden = YES;
    [self.maskView addTarget:self action:@selector(maskViewTouchHandler) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setTitleList:(NSArray *)aList {
    if (_titleList) {
        _titleList = nil;
    }
    _titleList = aList;
    [self.tableView reloadData];
    self.titleLabel.text = [_titleList firstObject];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleButton.frame = CGRectMake(0, 0, self.width, 51.5f);
    
    self.imageView.x = self.width - 15.0f - self.imageView.width;
    self.imageView.y = (self.titleButton.height - self.imageView.height) * 0.5f;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.x = self.imageView.x - 20.0f - self.titleLabel.width;
    self.titleLabel.y = (self.titleButton.height - self.titleLabel.height) * 0.5f;
    
    
    self.tableView.y = self.titleButton.height + 0.5f;
    self.tableView.width = self.width;
    self.tableView.height = self.titleList.count * 44.0f;
//    self.tableView.x = self.width - self.tableView.width;
    
    self.maskView.y = self.tableView.y + self.tableView.height;
    self.maskView.width = self.tableView.width;
    self.maskView.height = keyAppWindow.height - self.maskView.y;
//    self.maskView.x = self.tableView.x;
}

-(void)titleButtonTouchHandler {
    self.tableView.hidden = !self.tableView.hidden;
    self.maskView.hidden = !self.maskView.hidden;
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform,M_PI);
    }];
}

-(void)maskViewTouchHandler {
    self.maskView.hidden = YES;
    self.tableView.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = color18_other_xgw;
        line.frame = CGRectMake(0, 43.5f, tableView.width, 0.5f);
        [cell addSubview:line];
    }
    cell.textLabel.text = [self.titleList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = color2_text_xgw;
    cell.textLabel.font = font3_common_xgw;
    cell.textLabel.x = 20.0f;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableView.hidden = YES;
    self.maskView.hidden = YES;
    self.titleLabel.text = [self.titleList objectAtIndex:indexPath.row];
    [UIView animateWithDuration:kAnimationTimerInterval animations:^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform,M_PI);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemWithTitle:)]) {
        [self.delegate didSelectItemWithTitle:[self.titleList objectAtIndex:indexPath.row]];
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.tableView.hidden == YES) {
        if (point.y > 0.0f && point.y < self.titleButton.height) {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        if (point.y > 0.0f && point.y < self.height) {
            return YES;
        }
        else {
            return NO;
        }
    }
}
@end

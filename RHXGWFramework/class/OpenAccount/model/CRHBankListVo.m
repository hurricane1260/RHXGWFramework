//
//  CRHBankListVo.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/5/31.
//
//

#import "CRHBankListVo.h"

@implementation CRHBankListVo


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.branch_no forKey:@"branch_no"];
    [aCoder encodeObject:self.bank_no forKey:@"bank_no"];
    [aCoder encodeObject:self.bank_name forKey:@"bank_name"];
    [aCoder encodeObject:self.fun_flag forKey:@"fun_flag"];
    [aCoder encodeObject:self.pinyin forKey:@"pinyin"];
    [aCoder encodeObject:self.econtract_id forKey:@"econtract_id"];
    [aCoder encodeObject:self.verify_bank_id forKey:@"verify_bank_id"];
    [aCoder encodeObject:self.card_name forKey:@"card_name"];
    [aCoder encodeObject:self.pwd_name forKey:@"pwd_name"];
    [aCoder encodeObject:self.depository_memo forKey:@"depository_memo"];
    [aCoder encodeObject:self.bank_type forKey:@"bank_type"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.branch_no = [aDecoder decodeObjectForKey:@"branch_no"];
        self.bank_no = [aDecoder decodeObjectForKey:@"bank_no"];
        self.bank_name = [aDecoder decodeObjectForKey:@"bank_name"];
        self.fun_flag = [aDecoder decodeObjectForKey:@"fun_flag"];
        self.pinyin = [aDecoder decodeObjectForKey:@"pinyin"];
        self.econtract_id = [aDecoder decodeObjectForKey:@"econtract_id"];
        self.verify_bank_id = [aDecoder decodeObjectForKey:@"verify_bank_id"];
        self.card_name = [aDecoder decodeObjectForKey:@"card_name"];
        self.pwd_name = [aDecoder decodeObjectForKey:@"pwd_name"];
        self.depository_memo = [aDecoder decodeObjectForKey:@"depository_memo"];
        self.bank_type = [aDecoder decodeObjectForKey:@"bank_type"];

    }
    return self;
}

@end

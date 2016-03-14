//
//  XPAPIManager+HappyLife.m
//  XPApp
//
//  Created by jy on 16/1/13.
//  Copyright 2016年 ShareMerge. All rights reserved.
//

#import "XPAPIManager+Analysis.h"
#import "XPAPIManager+HappyLife.h"
#import <XPKit.h>

@implementation XPAPIManager (HappyLife)

- (RACSignal *)happyLifeWithDate:(NSString *)date time:(NSString *)time billType:(BillType)billType cityCode:(NSString *)cityCode
{
    if (cityCode.length < 1) {
        return nil;
    }
    NSString * billTypeStr;
    switch (billType) {
        case BillTypeOfLifeService:
            billTypeStr = @"010";
            break;
        case BillTypeOfFinancialService:
            billTypeStr = @"030";
            break;
        case BillTypeOfEntertainmentTravel:
            billTypeStr = @"020";
            break;
        case BillTypeOfPay:
            billTypeStr = @"100";
            break;
        case BillTypeOfMedical:
            billTypeStr = @"600";
            break;
        case BillTypeOfEduication:
            billTypeStr = @"500";
            break;
        default:
            break;
    }
    NSString *webUrl = [NSString stringWithFormat:@"http://life.ccb.com/tran/WCCMainPlatV5?TXCODE=520100&PROV_CODE=320000&BRANCHID=320000000&BILL_TYPE=%@&TIME=%@&MAC=%@&CCB_IBSVersion=V5&SERVLET_NAME=WCCMainPlatV5&DATE=%@&MER_CHANNEL=0&MERCHANTID=YSH320000000004&CITY_CODE=%@",billTypeStr,time,[self lifeSignatureWithDate:date time:time],date,cityCode];
    return [RACSignal return:webUrl];
}

- (NSString *)lifeSignatureWithDate:(NSString *)date time:(NSString *)time
{
    NSString *signature = [NSString stringWithFormat:@"MERCHANTID=YSH320000000004BRANCHID=320000000MER_CHANNEL=0DATE=%@TIME=%@263716941221556944139409",date,time];
    return [signature MD5];
}


@end

//
//  FNLimit.h
//  NumberPadDemo
//
//  Created by fly on 16/3/28.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, FNTextFieldLimitType) {
    FNTextFieldLimitTypeNone,
    FNTextFieldLimitTypePureUInt,//无符整数
    FNTextFieldLimitTypeFloat,//浮点数
};


@interface FNTextFieldLimit : NSObject

+ (instancetype)limit;

@property (nonatomic, assign) FNTextFieldLimitType limitType;

//总长度
@property(nonatomic, assign) NSUInteger totalInputLength;
//小数点几位
@property(nonatomic, assign) NSUInteger decimalPointLength;

//正则表示
@property(nonatomic, readonly, copy) NSString *regularExpression;

- (BOOL)validTextField:(NSString *)target shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)aString;


@end

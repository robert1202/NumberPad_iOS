//
//  FNLimit.m
//  NumberPadDemo
//
//  Created by fly on 16/3/28.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import "FNTextFieldLimit.h"

@interface FNTextFieldLimit ()

@property(nonatomic, readwrite, copy) NSString *regularExpression;

@end

@implementation FNTextFieldLimit

+ (instancetype)limit{
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.totalInputLength = 10;
        self.decimalPointLength = 2;
    }
    return self;
}

- (BOOL)validTextField:(NSString *)target shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)aString{
    
    if (range.length > 0) {
        return YES;
    }
    
    if ([self.regularExpression length] <= 0) {
        return YES;
    }
    
    return [self validateInputWithString:[target stringByAppendingString:aString]];
}

- (BOOL)validateInputWithString:(NSString *)aString{
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"error %@", error);
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aString
                                                        options:0
                                                          range:NSMakeRange(0, [aString length])];
    return (numberOfMatches > 0);
}

- (void)setLimitType:(FNTextFieldLimitType)limitType{
    _limitType = limitType;
    NSString *newRegular = @"";
    switch (limitType) {
        case FNTextFieldLimitTypeNone: {
            newRegular = @"";
            break;
        }
        case FNTextFieldLimitTypePureUInt: {
            newRegular = [NSString stringWithFormat:@"^([1-9]{1})(\\d{0,%@})$",@(MAX(self.totalInputLength - 1, 0))];
            break;
        }
        case FNTextFieldLimitTypeFloat: {
            newRegular = [NSString stringWithFormat:@"^(\\d{0,%@}+\\.?+\\d{0,%@})$",@(MAX(self.totalInputLength - 1, 0)),@(self.decimalPointLength)];
            break;
        }
        default:{
            newRegular = @"";
            break;
        }
    }
    self.regularExpression = newRegular;
}

@end

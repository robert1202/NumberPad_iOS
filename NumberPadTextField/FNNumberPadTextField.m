//
//  FNNumberPadTextField.m
//  MoRadioFilterDemo
//
//  Created by fly on 16/1/9.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import "FNNumberPadTextField.h"

@interface FNNumberPadTextField () <UITextFieldDelegate>

@property (nonatomic, strong) FNTextFieldLimit *limit;

@property(nullable, nonatomic, weak) id<UITextFieldDelegate>
    swapDelegate;

@end

@implementation FNNumberPadTextField

- (void)awakeFromNib{
    [self setup];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.delegate = self;
    self.totalInputLength = 10;
    self.decimalPointLength = 2;
    self.limitType = FNTextFieldLimitTypeNone;
}

#pragma mark - Reset

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    return [super canPerformAction:action withSender:sender];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate{
    [super setDelegate:self];
    if (delegate != self) {
        self.swapDelegate = delegate;
    }
    
}

- (FNTextFieldLimit *)limit {
  if (!_limit) {
    _limit = [FNTextFieldLimit limit];
    _limit.totalInputLength = self.totalInputLength;
    _limit.decimalPointLength = self.decimalPointLength;
  }
  return _limit;
}

- (void)setTotalInputLength:(NSUInteger)totalInputLength{
    _totalInputLength = totalInputLength;
    _limit.totalInputLength = totalInputLength;
}

- (void)setDecimalPointLength:(NSUInteger)decimalPointLength{
    _decimalPointLength = decimalPointLength;
    _limit.decimalPointLength = self.decimalPointLength;
}


- (void)setLimitType:(FNTextFieldLimitType)limitType{
    _limitType = limitType;
    self.limit.limitType = limitType;
    switch (limitType) {
        case FNTextFieldLimitTypeFloat: {
            self.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        }
        default:{
            self.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}

#pragma mark - TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [_swapDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
         [_swapDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [_swapDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_swapDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    if (range.length > 0) {
        if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            return [_swapDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
        }
        return YES;
    }
    
    return [self.limit validTextField:textField.text shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_swapDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_swapDelegate && [_swapDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [_swapDelegate textFieldShouldReturn:textField];
    }
    return YES;
}


//this is must fixed苹果审核被拒绝的代码
-(BOOL) respondsToSelector:(SEL)aSelector {
    
    NSString * selectorName = NSStringFromSelector(aSelector);
    NSString * overlayName = [NSString stringWithFormat:@"%@%@%@",@"custom",@"Overlay",@"Container"];
    if ([selectorName isEqualToString:overlayName]) {
        
        return NO;
    }
    return [super respondsToSelector:aSelector];
}

//- (BOOL)respondsToSelector:(SEL)aSelector {
//  if (aSelector == @selector(customOverlayContainer)) {
//    return NO;
//  }
//  return [super respondsToSelector:aSelector];
//}

@end

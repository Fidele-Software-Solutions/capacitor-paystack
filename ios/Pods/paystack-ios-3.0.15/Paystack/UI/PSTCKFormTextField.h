//
//  PSTCKFormTextField.h
//  Paystack
//

#import <UIKit/UIKit.h>

@class PSTCKFormTextField;

@protocol PSTCKFormTextFieldDelegate <UITextFieldDelegate>

- (void)formTextFieldDidBackspaceOnEmpty:(nonnull PSTCKFormTextField *)formTextField;

@end

@interface PSTCKFormTextField : UITextField

@property(nonatomic, readwrite, nullable) UIColor *defaultColor;
@property(nonatomic, readwrite, nullable) UIColor *errorColor;
@property(nonatomic, readwrite, nullable) UIColor *placeholderColor;

@property(nonatomic, readwrite, assign)BOOL formatsCardNumbers;
@property(nonatomic, readwrite, assign)BOOL validText;
@property(nonatomic, readwrite, weak, nullable)id<PSTCKFormTextFieldDelegate>formDelegate;

- (CGSize)measureTextSize;

@end

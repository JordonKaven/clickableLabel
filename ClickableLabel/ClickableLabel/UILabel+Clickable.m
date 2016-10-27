//
//  UILabel+Clickable.m
//  ClickableLabel
//
//  Created by 彭柯柱 on 2016/10/27.
//  Copyright © 2016年 彭柯柱. All rights reserved.
//

#define DEFAULT_UNDERLINE_COLOR [UIColor blueColor]
#define DEFAULT_UNDERLINE_TOP_CONSTRAINT 2

#import "UILabel+Clickable.h"
#import "objc/runtime.h"

@interface UILabel ()

@property (nonatomic, strong) actionBlock tempActionBlock;
@property (nonatomic, strong) NSTextContainer *labelTextContainter;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, copy) NSString *tempString;

@end

@implementation UILabel (Clickable)

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
	[self configure];
  }
  return self;
}

- (void)configure {
  self.layoutManager = [[NSLayoutManager alloc] init];
  self.labelTextContainter = [[NSTextContainer alloc] initWithSize:CGSizeZero];
  self.textStorage = [[NSTextStorage alloc] init];
  
  self.labelTextContainter.lineFragmentPadding = 0.f;
  self.labelTextContainter.lineBreakMode = self.lineBreakMode;
  self.labelTextContainter.maximumNumberOfLines = self.numberOfLines;
  [self.layoutManager addTextContainer:self.labelTextContainter];
  [self.textStorage addLayoutManager:self.layoutManager];
}

- (void)addAction:(actionBlock)action forString:(NSString *)string underLine:(BOOL)needUnderLine {
  [self addAction:action forString:string underLine:needUnderLine stringColor:DEFAULT_UNDERLINE_COLOR];
}

- (void)addAction:(actionBlock)action forString:(NSString *)string underLine:(BOOL)needUnderLine stringColor:(UIColor *)stringColor {
  self.tempString = string;
  NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
  [attributeString addAttribute:NSForegroundColorAttributeName value:stringColor range:[self rangeOfString:string]];
  if (needUnderLine) {
	  [attributeString addAttribute:NSUnderlineStyleAttributeName value:@(DEFAULT_UNDERLINE_TOP_CONSTRAINT) range:[self rangeOfString:string]];
  } else {
	  [attributeString addAttribute:NSUnderlineStyleAttributeName value:@0 range:[self rangeOfString:string]];
  }
  self.attributedText = attributeString;
  self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];
  if (action) {
	[self addTapGestureWithAction:action forString:string];
  }
}

- (void)addTapGestureWithAction:(actionBlock)action forString:(NSString *)tapString {
  self.tempActionBlock = action;
  UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [self addGestureRecognizer:tapGes];
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
  
  CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
  CGSize labelSize = tapGesture.view.bounds.size;
  CGRect textBoundingBox = [self.layoutManager usedRectForTextContainer:self.labelTextContainter];
  CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
											(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
  CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
													   locationOfTouchInLabel.y - textContainerOffset.y);
  NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer
														  inTextContainer:self.labelTextContainter
								 fractionOfDistanceBetweenInsertionPoints:nil];
  
  NSLog(@"%@", NSStringFromCGSize(self.labelTextContainter.size));
  if (NSLocationInRange(indexOfCharacter, [self rangeOfString:self.tempString])) {
	if (self.tempActionBlock) {
	  self.tempActionBlock();
	}
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
//  self.labelTextContainter.size = self.bounds.size;
}

#pragma mark -- tool

- (NSRange)rangeOfString:(NSString *)string {
  return [self.text rangeOfString:string];
}

- (void)setObject:(id)object byKey:(SEL)key associationPolicy:(objc_AssociationPolicy)associationPolicy {
  objc_setAssociatedObject(self, key, object, associationPolicy);
}

- (id)objectForkey:(SEL)key {
  return objc_getAssociatedObject(self, key);
}

- (actionBlock)tempActionBlock {
  return [self objectForkey:@selector(setTempActionBlock:)];
}

- (void)setTempActionBlock:(actionBlock)tempActionBlock {
  [self setObject:tempActionBlock byKey:@selector(setTempActionBlock:) associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (NSTextContainer *)labelTextContainter {
  return [self objectForkey:@selector(setLabelTextContainter:)];
}

- (void)setLabelTextContainter:(NSTextContainer *)labelTextContainter {
  [self setObject:labelTextContainter byKey:@selector(setLabelTextContainter:) associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (NSLayoutManager *)layoutManager {
  return [self objectForkey:@selector(setLayoutManager:)];
}

- (void)setLayoutManager:(NSLayoutManager *)layoutManager {
  [self setObject:layoutManager byKey:@selector(setLayoutManager:) associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)setTextStorage:(NSTextStorage *)textStorage {
  [self setObject:textStorage byKey:@selector(setTextStorage:) associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (NSTextStorage *)textStorage {
  return [self objectForkey:@selector(setTextStorage:)];
}

- (void)setTempString:(NSString *)tempString {
  [self setObject:tempString byKey:@selector(setTempString:) associationPolicy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (NSString *)tempString {
  return [self objectForkey:@selector(setTempString:)];
}

@end

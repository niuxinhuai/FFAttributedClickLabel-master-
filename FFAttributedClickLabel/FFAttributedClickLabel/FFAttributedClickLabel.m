//
//  FFAttributedClickLabel.m
//  FFAttributedClickLabel
//
//  Created by Mr.Yao on 16/5/14.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "FFAttributedClickLabel.h"
#import <CoreText/CoreText.h>

@implementation FFAttributedClickItem

@end

@implementation FFAttributedClickLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setText:(NSString *)text {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [self setTextStyle:str];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    NSInteger count = _linkArray.count;
    for (int i = 0; i < count; i++) {
        FFAttributedClickItem *model = _linkArray[i];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:model.range];
    }

    [super setAttributedText:str];
}

- (void)setLinkArray:(NSMutableArray *)linkArray {
    _linkArray = linkArray;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [self setTextStyle:str];
}

- (void)setTextStyle:(NSMutableAttributedString *)str {
    NSInteger count = _linkArray.count;
    for (int i = 0; i < count; i++) {
        FFAttributedClickItem *model = _linkArray[i];

        [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:model.range];
    }
    self.attributedText = str;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    [self getClickFrame:point
            resultBlock:^(BOOL isSucceec, FFAttributedClickItem *model) {
              if ([self.delegate respondsToSelector:@selector(FFAttrbutedLabel:click:)]) {
                  [self.delegate FFAttrbutedLabel:self click:model];
              }
            }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSInteger count = _linkArray.count;
    for (int i = 0; i < count; i++) {
        FFAttributedClickItem *model = _linkArray[i];

        [str addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:model.range];
    }
    [super setAttributedText:str];
}

- (BOOL)getClickFrame:(CGPoint)point resultBlock:(void (^)(BOOL isSucceec, FFAttributedClickItem *model))Block {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);

    CGMutablePathRef Path = CGPathCreateMutable();

    CGPathAddRect(Path, NULL, self.bounds);

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);

    CFArrayRef lines = CTFrameGetLines(frame);

    CFIndex count = CFArrayGetCount(lines);

    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);

    CGAffineTransform transform = [self transformForCoreText];
    CGFloat verticalOffset = 0;

    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];

        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];

        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);

        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));

            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);

            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);

            if (offset > relativePoint.x) {
                index = index - 1;
            }

            NSInteger link_count = _linkArray.count;
            for (int j = 0; j < link_count; j++) {

                FFAttributedClickItem *model = _linkArray[j];

                NSRange link_range = model.range;

                if (index >= link_range.location && index < (link_range.location + link_range.length)) {
                    Block(YES, model);
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self getClickFrame:point
                resultBlock:^(BOOL isSucceec, FFAttributedClickItem *model){

                }]) {
        return self;
    }
    return nil;
}

- (CGAffineTransform)transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;

    return CGRectMake(point.x, point.y - descent, width, height);
}

@end

//
//  FFAttributedClickLabel.h
//  FFAttributedClickLabel
//
//  Created by Mr.Yao on 16/5/14.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAttributedClickItem : NSObject //若需要更多属性可以继承

@property (assign, nonatomic) NSRange range;

@property (copy, nonatomic) NSString * url;

@end

@class FFAttributedClickLabel;

@protocol FFAttributedClickLabelDelegate <NSObject>

- (void)FFAttrbutedLabel:(FFAttributedClickLabel *)label click:(FFAttributedClickItem *)model;

@end


@interface FFAttributedClickLabel : UILabel


@property (assign, nonatomic) id  <FFAttributedClickLabelDelegate>delegate;

@property (strong, nonatomic) NSMutableArray * linkArray;

@end

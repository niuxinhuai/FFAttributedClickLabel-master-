//
//  ViewController.m
//  FFAttributedClickLabel
//
//  Created by Mr.Yao on 16/5/14.
//  Copyright © 2016年 Mr.Yao. All rights reserved.
//

#import "ViewController.h"
#import "FFAttributedClickLabel.h"

@interface ViewController ()<FFAttributedClickLabelDelegate>

@property (weak, nonatomic) IBOutlet FFAttributedClickLabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.delegate = self;

    NSMutableArray *range_array = [[NSMutableArray alloc]init];
    
    NSString *text_label_text = @"我是个Label， 我有一只小毛驴，我是大蠢绿";
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:text_label_text];
    
    NSString *string = @"小毛驴";
    
    NSRange text_range1 = [[attributedString string] rangeOfString:string];
    FFAttributedClickItem *model1 = [[FFAttributedClickItem alloc]init];
    model1.url = string;
    model1.range = text_range1;
    [range_array addObject:model1];
    
    
    NSString *string2 = @"大蠢绿";
    NSRange text_range2 =  [[attributedString string] rangeOfString:string2];
    FFAttributedClickItem *model2 = [[FFAttributedClickItem alloc]init];
    model2.url = string2;
    model2.range = text_range2;
    [range_array addObject:model2];
    
    
    self.label.attributedText = attributedString;
    self.label.linkArray = range_array;
    
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.lineBreakMode = kCTLineBreakByCharWrapping;
}

-(void)FFAttrbutedLabel:(FFAttributedClickLabel *)label click:(FFAttributedClickItem *)model{
    NSLog(@"%@ %@",model.url, NSStringFromRange(model.range));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

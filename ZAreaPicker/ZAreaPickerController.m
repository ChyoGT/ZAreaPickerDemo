//
//  ZAreaPickerController.m
//  ZAreaPickerDemo
//
//  Created by 张彦东 on 16/3/8.
//  Copyright © 2016年 zhang.yD. All rights reserved.
//

#import "ZAreaPickerController.h"
#import "ChineseToPinyin.h"
#import "JSONKit.h"

@interface ZAreaPickerController ()

@property (nonatomic, assign) ZAreaType type;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;

@property (nonatomic, strong) NSArray * datas;
@property (nonatomic, strong) NSArray * datas1;
@property (nonatomic, strong) NSArray * datas2;
@property (nonatomic, strong) NSArray * datas3;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation ZAreaPickerController
{
    ZAreaSelectCompleteBlock _block;
}

+ (instancetype)areaPickerControllerWithType:(ZAreaType)type complete:(ZAreaSelectCompleteBlock)block {
    
    ZAreaPickerController * areaVC = [[self alloc] init];
    areaVC.type = type;
    [areaVC setCompleteBlock:block];
    return areaVC;
}

- (void)setCompleteBlock:(ZAreaSelectCompleteBlock)block {
    _block = block;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    //读取本地文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"province" ofType:@"txt"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *textFile  = [NSString stringWithContentsOfFile:filePath encoding:enc error:nil];
    
    self.datas = [textFile objectFromJSONString];
    NSMutableArray * mArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in self.datas) {
        [mArray addObject:dict[@"name"]];
    }
    
    [self makeGroupWithArray:mArray type:1];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //    [self.button1 makeCornerWithRadius:kRate005];
    //    [self.button2 makeCornerWithRadius:kRate005];
}

- (void)setup {
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"选择省份";
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:249.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.button1.titleLabel.font = [UIFont systemFontOfSize:13];
    self.button1.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0]
    ;
    
    self.button2.titleLabel.font = [UIFont systemFontOfSize:13];
    self.button2.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:235.0/255.0 blue:245.0/255.0 alpha:1.0]
    ;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger result = 0;
    switch (tableView.tag) {
        case 1:
            result = self.datas1.count;
            break;
        case 2:
            result = self.datas2.count;
            break;
        case 3:
            result = self.datas3.count;
            break;
        default:
            break;
    }
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary * dict;
    switch (tableView.tag) {
        case 1:
            dict = self.datas1[section];
            break;
        case 2:
            dict = self.datas2[section];
            break;
        case 3:
            dict = self.datas3[section];
            break;
        default:
            break;
    }
    return dict[@"letter"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary * dict;
    switch (tableView.tag) {
        case 1:
            dict = self.datas1[section];
            break;
        case 2:
            dict = self.datas2[section];
            break;
        case 3:
            dict = self.datas3[section];
            break;
        default:
            break;
    }
    return [dict[@"words"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellName = [NSString stringWithFormat:@"cell%ld", tableView.tag];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        [cell.textLabel setTextColor:[UIColor colorWithRed:28.0/255.0 green:97.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary * dict;
    switch (tableView.tag) {
        case 1:
            dict = self.datas1[indexPath.section];
            break;
        case 2:
            dict = self.datas2[indexPath.section];
            break;
        case 3:
            dict = self.datas3[indexPath.section];
            break;
        default:
            break;
    }
    
    NSArray * arr = dict[@"words"];
    cell.textLabel.text = arr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * str = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    switch (tableView.tag) {
        case 1:
        {
            for (NSDictionary * province in self.datas) {
                if ([province[@"name"] isEqualToString:str]) {
                    NSMutableArray * mArray = [[NSMutableArray alloc] init];
                    for (NSDictionary * citys in province[@"city"]) {
                        [mArray addObject:citys[@"name"]];
                    }
                    [self makeGroupWithArray:mArray type:2];
                    break;
                }
            }
            [self.button1 setTitle:str forState:UIControlStateNormal];
            self.button1.hidden = NO;
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
            self.title = @"选择城市";
        }
            break;
        case 2:
        {
            if (self.type == ZAreaTypeCity) {
                if (_block) {
                    _block(self.button1.titleLabel.text, str, nil);
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                for (NSDictionary * province in self.datas) {
                    if ([province[@"name"] isEqualToString:self.button1.titleLabel.text]) {
                        for (NSDictionary * citys  in province[@"city"]) {
                            if ([citys[@"name"] isEqualToString:str]) {
                                [self makeGroupWithArray:citys[@"area"] type:3];
                                break;
                            }
                        }
                    }
                }
                [self.button2 setTitle:str forState:UIControlStateNormal];
                self.button2.hidden = NO;
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
                self.title = @"选择地区";
            }
        }
            break;
        case 3:
            if (_block) {
                _block(self.button1.titleLabel.text, self.button2.titleLabel.text, str);
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSArray * sectionArray;
    switch (tableView.tag) {
        case 1:
            sectionArray = self.datas1;
            break;
        case 2:
            sectionArray = self.datas2;
            break;
        case 3:
            sectionArray = self.datas3;
            break;
        default:
            break;
    }
    
    NSMutableArray * sectionTitles = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in sectionArray) {
        [sectionTitles addObject:dict[@"letter"]];
    }
    return sectionTitles;
}

#pragma mark - Other
- (void)makeGroupWithArray:(NSArray *)array type:(int)type {
    
    // 创建空数组
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    for (int i = 'A'; i <= 'Z'; i++) {
        NSDictionary * dict = @{@"letter" : [NSString stringWithFormat:@"%c", i],
                                @"words" : [[NSMutableArray alloc] init]};
        [dataArray addObject:dict];
    }
    
    // 分组
    for (int i = 0; i < array.count; i++) {
        
        NSString * chn = array[i];
        NSString * pinyin = [ChineseToPinyin pinyinFromChiniseString:chn];
        if ([pinyin isEqualToString:@"ZHONGQING"]) {
            pinyin = @"CHONGQING";
        }
        char letter = [pinyin characterAtIndex:0];
        int index = letter - 'A';
        NSDictionary * tmpDict = dataArray[index];
        NSMutableArray * tmpArray = tmpDict[@"words"];
        [tmpArray addObject:chn];
    }
    
    // 删除空数组
    for (NSInteger i = dataArray.count - 1; i >= 0; i--) {
        NSDictionary * dict = dataArray[i];
        if ([dict[@"words"] count] == 0) {
            [dataArray removeObject:dict];
        }
    }
    
    // 刷新数据
    switch (type) {
        case 1:
            self.datas1 = dataArray;
            [self.tableView1 reloadData];
            break;
        case 2:
            self.datas2 = dataArray;
            [self.tableView2 reloadData];
            break;
        case 3:
            self.datas3 = dataArray;
            [self.tableView3 reloadData];
            break;
        default:
            break;
    }
}

- (IBAction)buttonClick:(UIButton *)button {
    button.hidden = YES;
    
    switch (button.tag) {
        case 11:
            self.button2.hidden = YES;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.title = @"选择省份";
            break;
        case 12:
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
            self.title = @"选择城市";
            break;
        default:
            break;
    }
}

@end

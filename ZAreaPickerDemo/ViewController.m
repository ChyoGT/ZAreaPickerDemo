//
//  ViewController.m
//  ZAreaPickerDemo
//
//  Created by 张彦东 on 16/3/8.
//  Copyright © 2016年 zhang.yD. All rights reserved.
//

#import "ViewController.h"
#import "ZAreaPickerController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectToCity:(id)sender {
    
    ZAreaPickerController * pick = [ZAreaPickerController areaPickerControllerWithType:ZAreaTypeCity complete:^(NSString *province, NSString *city, NSString *area) {
        self.showLabel.text = [NSString stringWithFormat:@"省份: %@\n 城市: %@\n", province, city];
    }];
    [self.navigationController pushViewController:pick animated:YES];
}


- (IBAction)selectToArea:(id)sender {
    
    ZAreaPickerController * pick = [ZAreaPickerController areaPickerControllerWithType:ZAreaTypeArea complete:^(NSString *province, NSString *city, NSString *area) {
        self.showLabel.text = [NSString stringWithFormat:@"省份: %@\n 城市: %@\n 地区: %@", province, city, area];
    }];
    [self.navigationController pushViewController:pick animated:YES];
}

@end

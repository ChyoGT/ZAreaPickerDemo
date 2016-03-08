//
//  ZAreaPickerController.h
//  ZAreaPickerDemo
//
//  Created by 张彦东 on 16/3/8.
//  Copyright © 2016年 zhang.yD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZAreaSelectCompleteBlock)(NSString * province, NSString * city, NSString * area);

typedef NS_ENUM(NSUInteger, ZAreaType) {
    ZAreaTypeCity,  // 精确到城市
    ZAreaTypeArea   // 精确到地区
};
@interface ZAreaPickerController : UIViewController

+ (instancetype)areaPickerControllerWithType:(ZAreaType)type complete:(ZAreaSelectCompleteBlock)block;

@end

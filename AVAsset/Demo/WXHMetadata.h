//
//  WXHMetadata.h
//  Demo
//
//  Created by Jerry on 2017/11/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "THGenre.h"

@interface WXHMetadata : NSObject
@property (nonatomic, copy) NSString *name;//歌名
@property (nonatomic, copy) NSString *artist;//艺人
@property (nonatomic, copy) NSString *albumArtist;//专辑的主导艺人
@property (nonatomic, copy) NSString *album;//唱片集
@property (nonatomic, copy) NSString *grouping;//分类
@property (nonatomic, copy) NSString *composer;//作曲家
@property (nonatomic, copy) NSString *comments;//注解
@property (nonatomic, strong) UIImage *artwork;//封面
@property (nonatomic, copy) NSString *year;
@property (nonatomic, strong) NSNumber *bpm; //每分钟节拍数
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) NSNumber *trackCount;
@property (nonatomic, strong) NSNumber *discNumber;
@property (nonatomic, strong) NSNumber *discCount;
@property (nonatomic, strong) THGenre *genre;

- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key;
- (NSArray *)metadataItems;
@end

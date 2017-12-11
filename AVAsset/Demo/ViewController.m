//
//  ViewController.m
//  Demo
//
//  Created by Jerry on 2017/10/31.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVMetadataItem+Additions.h"
#import "WXHMediaItem.h"
@interface ViewController ()
@property (nonatomic, strong) NSArray *musicGenre;
@property (nonatomic, strong) NSArray *videoGenre;
@property (nonatomic, strong) AVAssetExportSession *exportSession;
@property (nonatomic, strong) NSMutableArray *metadataItems;
@end

@implementation ViewController
- (instancetype)init
{
    if (self = [super init]) {
        _musicGenre = [THGenre musicGenres];
        _videoGenre = [THGenre videoGenres];
        _metadataItems = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Happy" withExtension:@"mp3"];
    WXHMediaItem *item = [[WXHMediaItem alloc] initWithURL:url];
    [item prepareWithCompletionHandler:^(BOOL complete) {
        if (item.editable) {
            item.metadata.name = @"Hello AAC";
            [item saveWithCompletionHandler:^(BOOL complete) {
                if (complete) {
                    NSLog(@"save success!");
                }
            }];
        }
        NSLog(@"is prepared!");
    }];
    
}


- (void)test {
    //创建资源
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"01 Demo AAC" withExtension:@"m4a"];
//    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:options];

//Assets库
//遍历保存的照片
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
//                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                               //设置过滤，找到所以视频资源
//                               [group setAssetsFilter:[ALAssetsFilter allVideos]];
//                               //获得第一个
//                               [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0]
//                                                       options:NSEnumerationConcurrent
//                                                    usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                                                        if (result) {
//                                                            id representation = [result defaultRepresentation];
//                                                            NSURL *url = [representation url];
//                                                            AVAsset *asset = [AVAsset assetWithURL:url];
//                                                            NSLog(@"");
//                                                        }
//                                                    }];
//                           } failureBlock:^(NSError *error) {
//                               NSLog(@"Error : %@",[error localizedDescription]);
//                           }];

//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"01 Demo AAC" withExtension:@"m4a"];
//
//    AVAsset *asset = [AVAsset assetWithURL:url];

//    NSArray *keys = @[@"tracks"];
//    [asset loadValuesAsynchronouslyForKeys:keys
//                         completionHandler:^{
//                             NSError *error = nil;
//                             AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:&error];
//
//                             switch (status) {
//                                 case AVKeyValueStatusLoaded:
//
//                                     break;
//                                 case AVKeyValueStatusFailed:
//
//                                     break;
//                                 case AVKeyValueStatusCancelled:
//
//                                     break;
//
//                                 default:
//                                     break;
//                             }
//                         }];

//使用key来匹配键和键空间标准的对象
//    NSArray *keys = @[@"availableMetadataFormats"];
//    [asset loadValuesAsynchronouslyForKeys:keys
//                         completionHandler:^{
//                             NSMutableArray *metadata = [NSMutableArray array];
//                             for (NSString *format in asset.availableMetadataFormats) {
//                                 [metadata addObjectsFromArray:[asset metadataForFormat:format]];
//                             }
//
//                             NSString *keySpace = AVMetadataKeySpaceiTunes;
//                             NSString *artistKey = AVMetadataiTunesMetadataKeyArtist;
//                             NSString *albumKey = AVMetadataiTunesMetadataKeyAlbum;
//
//                             NSArray *artistMetadata = [AVMetadataItem metadataItemsFromArray:metadata withKey:artistKey keySpace:keySpace];
//                             NSArray *albumMetadata = [AVMetadataItem metadataItemsFromArray:metadata withKey:albumKey keySpace:keySpace];
//
//                             AVMetadataItem *artistItem, *ablumItem;
//                             if (artistMetadata.count > 0) {
//                                 artistItem = artistMetadata[0];
//                                 NSLog(@"%@",artistItem.value);
//                             }
//                             if (albumMetadata.count > 0) {
//                                 ablumItem = albumMetadata[0];
//                                 NSLog(@"%@",ablumItem.value);
//                             }
//                         }];

//    NSArray *metadata = [asset metadataForFormat:AVMetadataFormatiTunesMetadata];
//    for (AVMetadataItem *item in metadata) {
//        NSLog(@"%@ : %@",item.keyString,item.value);
//    }
    
}


@end

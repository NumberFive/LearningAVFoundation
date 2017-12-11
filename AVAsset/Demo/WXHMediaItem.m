//
//  WXHMediaItem.m
//  Demo
//
//  Created by Jerry on 2017/11/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHMediaItem.h"
#import "AVMetadataItem+Additions.h"
#import "NSFileManager+DirectoryLocations.h"

#define COMMON_META_KEY @"commonMetadata"
#define AVAILABLE_META_KEY @"availableMetadataFormats"

@interface WXHMediaItem ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) WXHMetadata *metadata;
@property (nonatomic, strong) NSArray *acceptedFormats;
@property (nonatomic, assign) BOOL prepared;
@end
@implementation WXHMediaItem
- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _url = url;
        _asset = [AVAsset assetWithURL:url];
        _filename = [url lastPathComponent];
        _filetype = [self fileTypeForURL:url];
        _editable = ![_filetype isEqualToString:AVFileTypeMPEGLayer3];
        _acceptedFormats = @[AVMetadataFormatQuickTimeMetadata,
                             AVMetadataFormatiTunesMetadata,
                             AVMetadataFormatID3Metadata];
    }
    return self;
}
- (void)prepareWithCompletionHandler:(WXHCompletionHandler)handler
{
    if (self.prepared) {
        handler(self.prepared);
        return;
    }
    self.metadata = [[WXHMetadata alloc] init];
    NSArray *keys = @[COMMON_META_KEY,AVAILABLE_META_KEY];
    [self.asset loadValuesAsynchronouslyForKeys:keys
                              completionHandler:^{
                                  AVKeyValueStatus commonStatus = [self.asset statusOfValueForKey:COMMON_META_KEY
                                                                                            error:nil];
                                  AVKeyValueStatus formatsStatus = [self.asset statusOfValueForKey:AVAILABLE_META_KEY
                                                                                             error:nil];
                                  self.prepared = (commonStatus == AVKeyValueStatusLoaded) && (formatsStatus == AVKeyValueStatusLoaded);
                                  if (self.prepared) {
                                      for (AVMetadataItem *item in self.asset.commonMetadata) {
                                          NSLog(@"%@: %@ : %@",item.key,item.keyString,item.value);
                                          [self.metadata addMetadataItem:item withKey:item.commonKey];
                                      }
                                  }
                                  for (id format in self.asset.availableMetadataFormats) {
                                      if ([self.acceptedFormats containsObject:format]) {
                                          NSArray *items = [self.asset metadataForFormat:format];
                                          for (AVMetadataItem *item in items) {
                                              NSLog(@"%@ : %@",item.keyString,item.value);
                                              [self.metadata addMetadataItem:item withKey:item.keyString];
                                          }
                                      }
                                  }
                                  handler(self.prepared);
                              }];
}
- (void)saveWithCompletionHandler:(WXHCompletionHandler)handler
{
    NSString *presetName = AVAssetExportPresetPassthrough;
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:self.asset
                                                                     presetName:presetName];
    NSURL *outputURL = [self tempURL];
    session.outputURL = outputURL;
    session.outputFileType = self.filetype;
    session.metadata = [self.metadata metadataItems];
    [session exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = session.status;
        BOOL success = status == AVAssetExportSessionStatusCompleted;
        if (success) {
            NSLog(@"%@",outputURL);
//            NSURL *sourceURL = self.url;
//            NSFileManager *manager = [NSFileManager defaultManager];
//            [manager removeItemAtURL:sourceURL error:nil];
//            [manager moveItemAtURL:outputURL toURL:sourceURL error:nil];
            [self reset];
        }
        if (handler) {
            handler(success);
        }
    }];
}
- (NSURL *)tempURL {
//    NSString *tempDir = NSTemporaryDirectory();
    NSString *tempDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *ext = [[self.url lastPathComponent] pathExtension];
    NSString *tempName = [NSString stringWithFormat:@"temp.%@", ext];
    NSString *tempPath = [tempDir stringByAppendingPathComponent:tempName];
    return [NSURL fileURLWithPath:tempPath];
}
- (void)reset {
    _prepared = NO;
    _asset = [AVAsset assetWithURL:self.url];
}
- (NSString *)fileTypeForURL:(NSURL *)url
{
    NSString *ext = [[self.url lastPathComponent] pathExtension];
    NSString *type = nil;
    if ([ext isEqualToString:@"m4a"]) {
        type = AVFileTypeAppleM4A;
    } else if ([ext isEqualToString:@"m4v"]) {
        type = AVFileTypeAppleM4V;
    } else if ([ext isEqualToString:@"mov"]) {
        type = AVFileTypeQuickTimeMovie;
    } else if ([ext isEqualToString:@"mp4"]) {
        type = AVFileTypeMPEG4;
    } else {
        type = AVFileTypeMPEGLayer3;
    }
    return type;
}
@end

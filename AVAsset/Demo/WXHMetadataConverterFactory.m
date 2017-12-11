//
//  WXHMetadataConverterFactory.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHMetadataConverterFactory.h"
#import "WXHMetadataKeys.h"
#import "WXHArtworkMetadataConverter.h"
#import "WXHCommentMetadataConverter.h"
#import "WXHDiscMetadataConverter.h"
#import "WXHGenreMetadataConverter.h"
#import "WXHTrackMetadataConverter.h"

@implementation WXHMetadataConverterFactory
- (id <WXHMetadataConverter>)converterForKey:(NSString *)key
{
    id <WXHMetadataConverter> converter = nil;
    if ([key isEqualToString:WXHMetadataKeyArtwork]) {
        converter = [[WXHArtworkMetadataConverter alloc] init];
    } else if ([key isEqualToString:WXHMetadataKeyTrackNumber]) {
        converter = [[WXHMetadataConverterFactory alloc] init];
    } else if ([key isEqualToString:WXHMetadataKeyComments]) {
        converter = [[WXHCommentMetadataConverter alloc] init];
    } else if ([key isEqualToString:WXHMetadataKeyGenre]) {
        converter = [[WXHGenreMetadataConverter alloc] init];
    } else {
        converter = [[WXHDefaultMetadatConverter alloc] init];
    }
    return converter;
}
@end

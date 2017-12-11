//
//  WXHGenreMetadataConverter.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHGenreMetadataConverter.h"
#import "THGenre.h"
@implementation WXHGenreMetadataConverter
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item
{
    THGenre *genre = nil;
    if ([item.value isKindOfClass:[NSString class]]) {
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
            if (item.numberValue) {
                NSUInteger  genreIndex = [item.numberValue unsignedIntegerValue];
                genre = [THGenre id3GenreWithIndex:genreIndex];
            } else {
                genre = [THGenre videoGenreWithName:item.stringValue];
            }
        } else {
            genre = [THGenre videoGenreWithName:item.stringValue];
        }
    }  else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        if (data.length == 2) {
            uint16_t *values = (uint16_t *)[data bytes];
            uint16_t genreIndex = CFSwapInt16BigToHost(values[0]);
            genre = [THGenre iTunesGenreWithIndex:genreIndex];
        }
    }
    return genre;
}
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    THGenre *genre = (THGenre *)value;
    if ([item.value isKindOfClass:[NSString class]]) {
        metadataItem.value = genre.name;
    } else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        if (data.length == 2) {
            uint16_t value = CFSwapInt16HostToBig(genre.index+1);
            size_t length = sizeof(value);
            metadataItem.value = [NSData dataWithBytes:&value length:length];
        }
    }
    return metadataItem;
}
@end

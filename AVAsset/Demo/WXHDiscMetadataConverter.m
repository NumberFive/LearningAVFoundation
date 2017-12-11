//
//  WXHDiscMetadataConverter.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHDiscMetadataConverter.h"

@implementation WXHDiscMetadataConverter
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item
{
    NSNumber *number = nil;
    NSNumber *count = nil;
    
    if ([item.value isKindOfClass:[NSString class]]) {
        NSArray *components = [item.stringValue componentsSeparatedByString:@"/"];
        number = @([components[0] integerValue]);
        count = @([components[1] integerValue]);
    } else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        if (data.length == 8) {
            uint16_t *values = (uint16_t *)[data bytes];
            if (values[1] > 0) {
                number = @(CFSwapInt16BigToHost(values[1]));
            }
            if (values[2] > 0) {
                count = @(CFSwapInt16BigToHost(values[2]));
            }
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:number ?: [NSNull null] forKey:WXHMetadataKeyDiscNumber];
    [dict setObject:count ?: [NSNull null] forKey:WXHMetadataKeyDiscCount];
    return dict;
}
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    NSDictionary *discData = (NSDictionary *)value;
    NSNumber *discNumber = discData[WXHMetadataKeyDiscNumber];
    NSNumber *discCount = discData[WXHMetadataKeyDiscCount];
    
    uint16_t values[4] = {0};
    if (discNumber && ![discNumber isKindOfClass:[NSNull class]]) {
        values[1] = CFSwapInt16HostToBig([discNumber unsignedIntegerValue]);
    }
    if (discCount && ![discCount isKindOfClass:[NSNull class]]) {
        values[2] = CFSwapInt16HostToBig([discCount unsignedIntegerValue]);
    }
    
    size_t length = sizeof(values);
    metadataItem.value = [NSData dataWithBytes:values length:length];
    return metadataItem;
}
@end

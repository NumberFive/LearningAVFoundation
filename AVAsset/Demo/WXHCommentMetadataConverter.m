//
//  WXHCommentMetadataConverter.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHCommentMetadataConverter.h"

@implementation WXHCommentMetadataConverter
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item
{
    NSString *value = nil;
    if ([item.value isKindOfClass:[NSString class]]) {
        value = item.stringValue;
    } else if ([item.value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)item.value;
        if (([dict[@"identifier"] isEqualToString:@""])) {
            value = dict[@"text"];
        }
    }
    return value;
}

- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = value;
    return metadataItem;
}
@end

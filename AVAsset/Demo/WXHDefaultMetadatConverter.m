//
//  WXHDefaultMetadatConverter.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHDefaultMetadatConverter.h"

@implementation WXHDefaultMetadatConverter
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item
{
    return item.value;
}
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(id)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    metadataItem.value = value;
    return metadataItem;
}
@end

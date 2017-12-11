//
//  WXHArtworkMetadataConverter.m
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHArtworkMetadataConverter.h"

@implementation WXHArtworkMetadataConverter
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item
{
    UIImage *image = nil;
    if ([item.value isKindOfClass:[NSData class]]) {
        image = [[UIImage alloc] initWithData:item.dataValue];
    } else if ([item.value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)item.value;
        image = [[UIImage alloc] initWithData:dict[@"data"]];
    }
    return image;
}
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value withMetadataItem:(AVMetadataItem *)item
{
    AVMutableMetadataItem *metadataItem = [item mutableCopy];
    
    UIImage *image = (UIImage *)value;
    metadataItem.value = UIImageJPEGRepresentation(image, 0.9);
    
    return metadataItem;
}
@end

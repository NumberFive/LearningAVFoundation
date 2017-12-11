//
//  AVAsset+Additions.m
//  Demo
//
//  Created by Jerry on 2017/11/15.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "AVAsset+Additions.h"

@implementation AVAsset (Additions)
- (NSString *)title
{
    AVKeyValueStatus status = [self statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items = [AVMetadataItem metadataItemsFromArray:self.commonMetadata
                                                        withKey:AVMetadataCommonKeyTitle
                                                       keySpace:AVMetadataKeySpaceCommon];
        if (items.count) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
    }
    return nil;
}
@end

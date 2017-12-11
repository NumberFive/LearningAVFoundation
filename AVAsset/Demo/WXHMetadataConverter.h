//
//  WXHMetadataConverter.h
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol WXHMetadataConverter <NSObject>
- (id)displayValueFormMetadataItem:(AVMetadataItem *)item;
- (AVMetadataItem *)metadataItemFromDisplayValue:(id)value
                                withMetadataItem:(AVMetadataItem *)item;
@end

//
//  WXHMetadataConverterFactory.h
//  Demo
//
//  Created by Jerry on 2017/11/6.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHDefaultMetadatConverter.h"
@interface WXHMetadataConverterFactory : WXHDefaultMetadatConverter
- (id <WXHMetadataConverter>)converterForKey:(NSString *)key;
@end

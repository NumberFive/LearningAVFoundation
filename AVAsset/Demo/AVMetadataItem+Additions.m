//
//  AVMetadataItem+Additions.m
//  Demo
//
//  Created by Jerry on 2017/11/1.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "AVMetadataItem+Additions.h"

@implementation AVMetadataItem (Additions)
- (NSString *)keyString
{
    if ([self.key isKindOfClass:[NSString class]]) {
        return (NSString *)self.key;
    } else if ([self.key isKindOfClass:[NSNumber class]]) {
        UInt32 keyValue = [(NSNumber *)self.key unsignedIntegerValue];
        size_t length = sizeof(UInt32);
        if ((keyValue >> 24) == 0) --length;
        if ((keyValue >> 16) == 0) --length;
        if ((keyValue >> 8) == 0) --length;
        if ((keyValue >> 0) == 0) --length;
        long address = (unsigned long)&keyValue;
        address += (sizeof(UInt32) - length);
        
        keyValue = CFSwapInt32BigToHost(keyValue);
        char cstring[length];
        strncpy(cstring, (char *)address, length);
        cstring[length] = '\0';
        
        if (cstring[0] == '\xA9') {
            cstring[0] = '@';
        }
        return [NSString stringWithCString:(char *)cstring encoding:NSUTF8StringEncoding];
    } else {
        return @"<<unknown>>";
    }
}
@end

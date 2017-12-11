//
//  WXHMetadata.m
//  Demo
//
//  Created by Jerry on 2017/11/3.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "WXHMetadata.h"
#import "WXHMetadataConverterFactory.h"

@interface WXHMetadata ()
@property (nonatomic, strong) NSDictionary *keyMapping;
@property (nonatomic, strong) NSMutableDictionary *metadata;
@property (nonatomic, strong) WXHMetadataConverterFactory *converterFactory;
@end
@implementation WXHMetadata
- (instancetype)init
{
    if (self = [super init]) {
        _keyMapping = [self buildKeyMapping];
        _metadata = [NSMutableDictionary dictionary];
        _converterFactory = [[WXHMetadataConverterFactory alloc] init];
    }
    return self;
}
- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key
{
    NSString *normalizedKey = self.keyMapping[key];
    if (normalizedKey) {
        id <WXHMetadataConverter> converter = [self.converterFactory converterForKey:normalizedKey];
        id value = [converter displayValueFormMetadataItem:item];
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data = (NSDictionary *)value;
            for (NSString *currentkey in data) {
                [self setValue:data[currentkey] forKey:currentkey];
            }
        } else {
            [self setValue:value forKey:normalizedKey];
        }
        self.metadata[normalizedKey] = item;
    }
}
- (NSArray *)metadataItems
{
    NSMutableArray *items = [NSMutableArray array];
    
    [self addMetadataItemForNumber:self.trackNumber
                             count:self.trackCount
                         numberKey:WXHMetadataKeyTrackNumber
                          countKey:WXHMetadataKeyTrackCount
                           toArray:items];
    
    [self addMetadataItemForNumber:self.discNumber
                             count:self.discCount
                         numberKey:WXHMetadataKeyDiscNumber
                          countKey:WXHMetadataKeyDiscCount
                           toArray:items];
    NSMutableDictionary *metaDict = [self.metadata mutableCopy];
    [metaDict removeObjectForKey:WXHMetadataKeyTrackNumber];
    [metaDict removeObjectForKey:WXHMetadataKeyDiscNumber];
    
    for (NSString *key in metaDict) {
        id <WXHMetadataConverter> converter = [self.converterFactory converterForKey:key];
        id value = [self valueForKey:key];
        AVMetadataItem *item = [converter metadataItemFromDisplayValue:value
                                                      withMetadataItem:metaDict[key]];
        if (item) {
            [items addObject:item];
        }
    }
    return items;
}

- (void)addMetadataItemForNumber:(NSNumber *)number
                           count:(NSNumber *)count
                       numberKey:(NSString *)numberKey
                        countKey:(NSString *)countKey
                         toArray:(NSMutableArray *)items
{
    id <WXHMetadataConverter> converter = [self.converterFactory converterForKey:numberKey];
    NSDictionary *data = @{numberKey : number ?: [NSNull null],
                           countKey : count ?: [NSNull null]};
    AVMetadataItem *sourceItem = self.metadata[numberKey];
    AVMetadataItem *item = [converter metadataItemFromDisplayValue:data
                                                  withMetadataItem:sourceItem];
    if (item) {
        [items addObject:item];
    }
}
- (NSDictionary *)buildKeyMapping {
    
    return @{
             // Name Mapping
             AVMetadataCommonKeyTitle : WXHMetadataKeyName,
             
             // Artist Mapping
             AVMetadataCommonKeyArtist : WXHMetadataKeyArtist,
             AVMetadataQuickTimeMetadataKeyProducer : WXHMetadataKeyArtist,
             
             // Album Artist Mapping
             AVMetadataID3MetadataKeyBand : WXHMetadataKeyAlbumArtist,
             AVMetadataiTunesMetadataKeyAlbumArtist : WXHMetadataKeyAlbumArtist,
             @"TP2" :WXHMetadataKeyAlbumArtist,
             
             // Album Mapping
             AVMetadataCommonKeyAlbumName : WXHMetadataKeyAlbum,
             
             // Artwork Mapping
             AVMetadataCommonKeyArtwork : WXHMetadataKeyArtwork,
             
             // Year Mapping
             AVMetadataCommonKeyCreationDate : WXHMetadataKeyYear,
             AVMetadataID3MetadataKeyYear : WXHMetadataKeyYear,
             @"TYE" : WXHMetadataKeyYear,
             AVMetadataQuickTimeMetadataKeyYear : WXHMetadataKeyYear,
             AVMetadataID3MetadataKeyRecordingTime : WXHMetadataKeyYear,
             
             // BPM Mapping
             AVMetadataiTunesMetadataKeyBeatsPerMin : WXHMetadataKeyBPM,
             AVMetadataID3MetadataKeyBeatsPerMinute : WXHMetadataKeyBPM,
             @"TBP" : WXHMetadataKeyBPM,
             
             // Grouping Mapping
             AVMetadataiTunesMetadataKeyGrouping : WXHMetadataKeyGrouping,
             @"@grp" : WXHMetadataKeyGrouping,
             AVMetadataCommonKeySubject : WXHMetadataKeyGrouping,
             
             // Track Number Mapping
             AVMetadataiTunesMetadataKeyTrackNumber : WXHMetadataKeyTrackNumber,
             AVMetadataID3MetadataKeyTrackNumber : WXHMetadataKeyTrackNumber,
             @"TRK" : WXHMetadataKeyTrackNumber,
             
             // Composer Mapping
             AVMetadataQuickTimeMetadataKeyDirector : WXHMetadataKeyComposer,
             AVMetadataiTunesMetadataKeyComposer : WXHMetadataKeyComposer,
             AVMetadataCommonKeyCreator : WXHMetadataKeyComposer,
             
             // Disc Number Mapping
             AVMetadataiTunesMetadataKeyDiscNumber : WXHMetadataKeyDiscNumber,
             AVMetadataID3MetadataKeyPartOfASet : WXHMetadataKeyDiscNumber,
             @"TPA" : WXHMetadataKeyDiscNumber,
             
             // Comments Mapping
             @"ldes" : WXHMetadataKeyComments,
             AVMetadataCommonKeyDescription : WXHMetadataKeyComments,
             AVMetadataiTunesMetadataKeyUserComment : WXHMetadataKeyComments,
             AVMetadataID3MetadataKeyComments : WXHMetadataKeyComments,
             @"COM" : WXHMetadataKeyComments,
             
             // Genre Mapping
             AVMetadataQuickTimeMetadataKeyGenre : WXHMetadataKeyGenre,
             AVMetadataiTunesMetadataKeyUserGenre : WXHMetadataKeyGenre,
             AVMetadataCommonKeyType : WXHMetadataKeyGenre
             };
}
@end

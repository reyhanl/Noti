//
//  ImageModel.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#include "ImageModel.h"

@implementation ImageModel


-(void) encodeWithCoder:(NSCoder *_Nonnull)coder{
    [coder encodeObject:_identifier forKey: @"identifier"];
    [coder encodeObject:_image forKey: @"image"];
}

- (instancetype)initWithCoder:(NSCoder *_Nonnull)coder
{
    self = [super init];
    if (self) {
        self.identifier = [coder decodeObjectForKey:@"identifier"];
        self.image = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *_Nonnull)dict
{
    self = [super init];
    if (self) {
        self.identifier = [dict valueForKey:@"identifier"];
        self.image = [dict valueForKey:@"image"];
    }
    return self;
}

-(NSDictionary *_Nonnull) dictionaryRepresantation{
    return @{
        @"identifier": self.identifier,
        @"image": self.image
    };
}

@end

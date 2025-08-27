//
//  Body.m
//  Practive
//
//  Created by reyhan muhammad on 2025/8/27.
//

#import "Body.h"


@implementation Body

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _attributedString = [[NSAttributedString alloc] initWithString:string];
    }
    return self;
}

+ (BOOL)supportsSecureCoding { return YES; }

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.attributedString forKey:@"attributedString"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _attributedString = [coder decodeObjectOfClass:NSAttributedString.class forKey:@"attributedString"];
    }
    return self;
}

@end

//
//  CustomAttachment.m
//  Practive
//
//  Created by reyhan muhammad on 30/01/24.
//

#import "CustomAttachment.h"

@implementation CustomAttachment
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.originalSize = [coder decodeCGSizeForKey:@"originalSize"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeCGSize:self.originalSize forKey:@"originalSize"];
}

- (UIImage *)image {
    if (super.image) {
        return [self roundedImageFromImage:super.image cornerRadius:8];
    }
    return nil;
}

- (UIImage *)roundedImageFromImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius {
    CGRect rect = (CGRect){CGPointZero, image.size};
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [image drawInRect:rect];
    UIImage *rounded = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rounded;
}

@end

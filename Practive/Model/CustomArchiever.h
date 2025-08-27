//
//  CustomArchiever.h
//  Practive
//
//  Created by reyhan muhammad on 18/01/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomTransformer : NSSecureUnarchiveFromDataTransformer

@property (class, readonly) NSValueTransformerName name;

+ (void)registerTransformer;

@end

@implementation CustomTransformer

@dynamic name;

+ (NSValueTransformerName)name {
    return NSStringFromClass(self);
}

+ (NSArray<Class> *)allowedTopLevelClasses {
    return @[NSAttributedString.class];
}

+ (void)registerTransformer {
    ColorValueTransformer *transformer = [ColorValueTransformer new];
    [NSValueTransformer setValueTransformer:transformer forName:self.name];
}

@end

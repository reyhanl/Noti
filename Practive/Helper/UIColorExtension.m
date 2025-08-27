//
//  ExtensionColor.m
//  Practive
//
//  Created by reyhan muhammad on 2025/8/26.
//

#import "UIColorExtension.h"

@implementation UIColor (Resolved)

- (UIColor *)dark {
    UITraitCollection *trait = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];
    return [self resolvedColorWithTraitCollection:trait];
}

- (UIColor *)light {
    UITraitCollection *trait = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight];
    return [self resolvedColorWithTraitCollection:trait];
}

@end

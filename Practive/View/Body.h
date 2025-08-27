//
//  Untitled.h
//  Practive
//
//  Created by reyhan muhammad on 2025/8/27.
//

#import <UIKit/UIKit.h>

@interface Body : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSAttributedString *attributedString;
- (instancetype)initWithString:(NSString *)string;
@end

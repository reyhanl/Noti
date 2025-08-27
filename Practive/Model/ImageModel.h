//
//  ImageModel.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#ifndef ImageModel_h
#define ImageModel_h

#endif /* ImageModel_h */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageModel: NSObject

@property(strong, nullable) NSString* identifier;
@property(strong, nullable) NSString* image;

- (instancetype)initWithDictionary:(NSDictionary *_Nonnull)dict;
- (instancetype)initWithCoder:(NSCoder *_Nonnull)coder;
-(NSDictionary *_Nonnull) dictionaryRepresantation;
@end

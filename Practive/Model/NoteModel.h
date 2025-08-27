//
//  NoteModel.h
//  Practive
//
//  Created by reyhan muhammad on 29/12/23.
//

#import <UIKit/UIKit.h>
#import "Body.h"

@interface NoteModel: NSObject<NSSecureCoding>

@property (strong, nullable) NSString* identifier;
@property (strong, nullable) Body* body;
@property (strong, nullable) NSString* title;
@property (strong, nullable) NSDate* lastModified;
@property (strong, nullable) NSNumber* emotion;
    
- (instancetype)initWithDictionary:(NSDictionary *_Nonnull)dict;
- (instancetype)initWithCoder:(NSCoder *_Nonnull)coder;
-(NSDictionary *_Nonnull) dictionaryRepresantation;
-(NSString*)getBody;
-(NSString*)getTitle;
-(UIImage*)getImage;
-(NSComparisonResult)compare:(NoteModel*)otherObject;
-(void)save;
@end


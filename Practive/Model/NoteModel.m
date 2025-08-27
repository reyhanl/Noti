//
//  NoteModel.m
//  Practive
//
//  Created by reyhan muhammad on 29/12/23.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
#import "NoteManager.h"

@implementation NoteModel

+ (BOOL)supportsSecureCoding{
    return true;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        NSDateFormatter *component = [[NSDateFormatter alloc] init];
        component.dateFormat = @"dd-MM-yyyy";
        
        self.identifier = [coder decodeObjectOfClass:NSString.class forKey:@"identifier"];
        self.body = [coder decodeObjectOfClass:Body.class forKey:@"body"];
        self.title = [coder decodeObjectOfClass:NSString.class forKey:@"title"];
        
        NSString *lastModified = [coder decodeObjectOfClass:NSString.class forKey:@"lastModified"];
        self.lastModified = [component dateFromString:lastModified];
        
        self.emotion = [coder decodeObjectOfClass:NSNumber.class forKey:@"emotion"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSDateFormatter *component = [[NSDateFormatter alloc] init];
    component.dateFormat = @"dd-MM-yyyy";

    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.body forKey:@"body"];
    [coder encodeObject:self.title forKey:@"title"];
    if (self.lastModified) {
        NSString *dateString = [component stringFromDate:self.lastModified];
        [coder encodeObject:dateString forKey:@"lastModified"];
    }
    [coder encodeObject:self.emotion forKey:@"emotion"];
}

- (instancetype)initWithDictionary:(NSDictionary *_Nonnull)dict
{
    self = [super init];
    if (self) {
        self.identifier = [dict valueForKey:@"identifier"];
        self.body = [dict valueForKey:@"body"];
        self.title = [dict valueForKey:@"title"];
        if ([dict valueForKey:@"emotion"]){
            self.emotion = [dict valueForKey:@"emotion"];
        }
        
        NSString *dateString = [dict valueForKey:@"lastModified"];
        if(![dateString isEqual:[NSNull null]]){
            NSDateFormatter *component = [[NSDateFormatter alloc] init];
            component.dateFormat = @"dd-mm-yyyy";
            
            NSDate *date = [component dateFromString:dateString];
            self.lastModified = date;
        }
    }
    return self;
}

-(NSDictionary *_Nonnull) dictionaryRepresantation{
    NSDateFormatter *component = [[NSDateFormatter alloc] init];
    component.dateFormat = @"dd-mm-yyyy";
    NSDate *date = [[NSDate date] init];
    NSString *dateString = [component stringFromDate:date];
    NSMutableDictionary *dict =  [[NSMutableDictionary alloc] initWithDictionary:@{
        @"identifier": self.identifier,
        @"body": self.body,
        @"title": self.title,
        @"lastModified": dateString
    }];
    if (self.emotion){
        [dict setObject:self.emotion forKey:@"emotion"];
    }

    return dict;
}

-(NSString *_Nonnull)getBody{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    NSUInteger len = [_body.attributedString.string length];
    unichar buffer[len+1];
    [_body.attributedString.string getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSAttributedString* tempAttrString = self.body.attributedString;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:tempAttrString];

    NSLog(@"getCharacters:range: with unichar buffer");
    bool isBody = false;
    bool isTitle = false;
    for(int i = 0; i < len; i++) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        NSRange range = NSMakeRange(i, 1);
        NSDictionary<NSAttributedStringKey, id> *dict = [attrString attributesAtIndex:i effectiveRange:&range];
        NSLog(@"dict: %@", charString);
        if([dict valueForKey:@"NSAttachment" ] == nil && !isBody && !isTitle){
            isTitle = true;
        }
        if ([charString  isEqual: @"\n"]){
            if (isBody && !isTitle){
                break;
            }else if (isTitle && !isBody){
                isBody = true;
                continue;
            }
        }
        if (isBody){
            [result appendString:charString];
        }
    }
    return result;
}

-(UIImage *_Nullable)getImage{
    NSAttributedString* tempAttrString = self.body.attributedString;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:tempAttrString];
    __block UIImage *image = nil;
    [attrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        NSTextAttachment *attachment = (NSTextAttachment *)value;
        if ([attachment image]){
            image = [attachment image];
        }
    }];
    return image;
}

-(NSString *_Nonnull)getTitle{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    NSUInteger len = [_body.attributedString length];
    unichar buffer[len+1];

    [_body.attributedString.string getCharacters:buffer range:NSMakeRange(0, len)];
    NSAttributedString* tempAttrString = self.body.attributedString;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:tempAttrString];

    NSLog(@"getCharacters:range: with unichar buffer");
    bool isTitle = false;
    for(int i = 0; i < len; i++) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        NSRange range = NSMakeRange(i, 1);
        NSDictionary<NSAttributedStringKey, id> *dict = [attrString attributesAtIndex:i effectiveRange:&range];
        if([dict valueForKey:@"NSAttachment" ] == nil && !isTitle){
            isTitle = true;
        }
        if ([charString  isEqual: @"\n"]){
            break;
        }
        if (isTitle){
            [result appendString:charString];
        }
    }
    return result;
}


- (NSComparisonResult)compare:(NoteModel *)otherObject {
    return [self.lastModified compare:otherObject.lastModified];
}

-(void)save:(NSError**)error{
    NoteManager *manager = [[NoteManager alloc] init];
    *error = [manager saveNote:self];
}
@end

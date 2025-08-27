//
//  ImageManager.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#include "ImageManager.h"

@implementation ImageManager


-(void)insert: (NSString*)identifier image:(UIImage *)image error:(NSError**) error{
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64Image = [data base64EncodedStringWithOptions:0];
    ImageModel *model = [[ImageModel alloc] initWithDictionary:@{@"identifier":identifier, @"image":base64Image}];
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    [manager saveData:Image dict:model.dictionaryRepresantation];
}

-(ImageModel*)fetchImage: (NSString*)identifier{
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSArray *array = [manager fetchData:Image with:predicate];
    for (NSManagedObject *obj in array){
        NSDictionary *dict = [obj dictionaryWithValuesForKeys:obj.entity.attributesByName.allKeys];
        ImageModel *model = [[ImageModel alloc] initWithDictionary:dict];
        return model;
    }
    return nil;
}
-(NSError * _Nullable)deleteImage:(NSString *_Nonnull)identifier{
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];

    [manager deleteData:Image predicate:predicate];
    return nil;
}
@end

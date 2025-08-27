//
//  ImageManager.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#ifndef ImageManager_h
#define ImageManager_h


#endif /* ImageManager_h */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "CoreDataManager.h"
#import "ImageModel.h"

@interface ImageManager: NSObject

-(void)insert: (NSString*)identifier image:(UIImage *)image error:(NSError**) error;
-(ImageModel*)fetchImage: (NSString*)identifier;
-(NSError * _Nullable)deleteImage:(NSString *_Nonnull)identifier;

@end

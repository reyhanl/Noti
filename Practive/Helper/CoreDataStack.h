//
//  CoreDataStack.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject


@property (strong, nonatomic) NSString* modelContainerName;
@property (strong, nonatomic) NSPersistentContainer* persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext* _Nullable context;
@property (strong, nonatomic) NSArray<NSPersistentStoreDescription *>* description;

- (instancetype)init: (NSString*) container;
-(void) assignContainer;

@end

//
//  CoreDataManager.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#ifndef CoreDataManager_h
#define CoreDataManager_h

#import "CoreDataStack.h"
#import <CoreData/CoreData.h>
#import "EntityEnum.h"
#import "NoteModel.h"

#endif /* CoreDataManager_h */

@interface CoreDataManager : NSObject
@property (strong, nonatomic) CoreDataStack* _Nullable stack;

- (instancetype _Nonnull )init:(CoreDataStack*_Nonnull) stack;
-(NSArray<NSManagedObject *>*_Nonnull) fetchData:(Entity _Nonnull) entityName with:(NSPredicate* _Nullable) predicate;
-(NSError* _Nullable) saveData: (Entity _Nullable)entityName dict:(NSDictionary*_Nonnull)dict;
-(NSError* _Nullable)deleteData:(Entity _Nonnull) entityName predicate:(NSPredicate*_Nullable) predicate;
-(NSError* _Nullable)editData:(Entity _Nonnull) entityName dictionary:(NSDictionary *_Nonnull)dictionary predicate:(NSPredicate*_Nonnull) predicate;
- (NSError *_Nullable)deleteDataWithEntity:(Entity _Nonnull)entityName predicate:(NSPredicate *_Nullable)predicate;
@end

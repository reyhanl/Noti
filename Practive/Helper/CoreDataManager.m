//
//  CoreDataManager.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

@implementation CoreDataManager
    
- (instancetype _Nonnull )init:(CoreDataStack*_Nonnull) stack
{
    self = [super init];
    if (self) {
        self.stack = stack;
    }
    return self;
}

-(NSArray<NSManagedObject *>*_Nonnull) fetchData:(Entity _Nonnull) entityName with:(NSPredicate* _Nullable) predicate{
        if (_stack.context){
            NSError* error = nil;
            NSString *name = entityName;
            NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName: name];
            request.predicate = predicate;
            NSArray<NSManagedObject*>* objects = [self.stack.context executeFetchRequest:request error:&error];
            if (objects == nil){
                NSLog(@"error: %@", error.localizedDescription);
            }else{
                return objects;
            }
        }
    return @[];
    }

-(NSError* _Nullable) saveData: (Entity _Nullable)entityName dict:(NSDictionary*_Nonnull)dict {
    NSError* error = nil;
    if (_stack.context){
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_stack.context];
        NSSet<NSString *> *keys = [NSSet setWithArray:managedObject.entity.attributesByName.allKeys];
        for (NSString* key in dict.allKeys){
            bool contain = [keys containsObject:key];
            if (contain){
                [managedObject setValue:dict[key] forKey:key];
            }
        }
        [self.stack.context save:&error];
        NSLog(@"hahahah");
        NSLog(@"%@", error.localizedDescription);
        return error;
    }
    error = [NSError errorWithDomain:@"context is non existent" code:1 userInfo:nil];
    return error;
}

-(NSError* _Nullable)deleteData:(Entity _Nonnull) entityName predicate:(NSPredicate*_Nullable) predicate{
    NSError* error = nil;
    if (_stack.context){
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        request.predicate = predicate;
        NSBatchDeleteRequest* deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        [_stack.context executeRequest:deleteRequest error:&error];
        NSLog(@"error: %@", error.localizedDescription);
        return error;
    }
    error = [NSError errorWithDomain:@"context is non existent" code:1 userInfo:nil];
    return error;
}

-(NSError* _Nullable)editData:(Entity _Nonnull) entityName dictionary:(NSDictionary *_Nonnull)dictionary predicate:(NSPredicate*_Nonnull) predicate{
    NSError* error = nil;
    if (_stack.context){
        NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:entityName];
        request.predicate = predicate;
        NSBatchUpdateResult *updateRequest = [[NSBatchUpdateResult alloc] init];
        
        NSArray *result = [_stack.context executeFetchRequest:request error:&error];
        NSManagedObject *obj = [result objectAtIndex:0];
        for (NSString *key in dictionary){
            if ([obj.entity.attributesByName.allKeys containsObject:key]){
                [obj setValue:[dictionary valueForKey:key] forKey: key];
            }
        }
        [_stack.context save:&error];
        return error;
    }
    error = [NSError errorWithDomain:@"context is non existent" code:1 userInfo:nil];
    return error;
}

- (NSError *_Nullable)deleteDataWithEntity:(Entity _Nonnull)entityName predicate:(NSPredicate *_Nullable)predicate {
    // Assuming you have a managed object context
    
    NSManagedObjectContext *managedObjectContext = _stack.context;

    // Create a fetch request for the specified entity
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:entityName];

    // Set the predicate if provided
    request.predicate = predicate;

    NSError *fetchError = nil;
    NSArray<NSManagedObject *> *objectsToDelete = [managedObjectContext executeFetchRequest:request error:&fetchError];

    if (fetchError) {
        // Handle fetch error
        NSLog(@"Fetch Error: %@", fetchError);
        return fetchError;
    }

    // Iterate through the fetched objects and delete each one
    for (NSManagedObject *object in objectsToDelete) {
        [managedObjectContext deleteObject:object];
    }

    // Save changes to persist the deletions
    NSError *saveError = nil;
    if (![managedObjectContext save:&saveError]) {
        // Handle save error
        NSLog(@"Save Error: %@", saveError);
        return saveError;
    }

    NSLog(@"Data deleted successfully from entity: %@", entityName);
    return nil; // Return nil to indicate success
}
@end


//
//  CoreDataStack.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>

#import "CoreDataStack.h"

@implementation CoreDataStack

//- (instancetype)init: (NSPersistentContainer*_Nonnull) container
//{
//    self = [super init];
//    if (self) {
//        self.persistentContainer = container;
//    }
//    return self;
//}

- (instancetype)init: (NSString*) container
{
    self = [super init];
    if (self) {
        _modelContainerName = container;
        [self assignContainer];
    }
    return self;
}

-(void) assignContainer{
    if (_modelContainerName){
        self.persistentContainer = [[NSPersistentContainer alloc] initWithName: _modelContainerName];
        [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull, NSError * _Nullable) {
            self.context = self->_persistentContainer.viewContext;
        }];
    }
}

@end

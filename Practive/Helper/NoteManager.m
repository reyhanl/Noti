//
//  NoteManager.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#import "NoteManager.h"
#import "Body.h"

@implementation NoteManager

-(NoteModel*)createNote{
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *identifier = uuid.UUIDString;
    Body *str = [[Body alloc] initWithString:@""];
    NSDictionary *myDictionary = @{
        @"body": str,
        @"identifier": identifier,
        @"title": @"",
        @"emotion": @6
    };
    
    NoteModel *note = [[NoteModel alloc] initWithDictionary:myDictionary];
    return note;
}


-(NSError* _Nullable)saveNote:(NoteModel*)note{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
        CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
        NSError *error = [manager saveData:Note dict:note.dictionaryRepresantation];
        NSLog(@"%@", error.localizedDescription);
    });
    return nil;
}


-(NSMutableArray<NoteModel*> *_Nonnull)fetchNotes{
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    NSArray *array = [manager fetchData:Note with:nil];
    NSMutableArray<NoteModel *> *result = [[NSMutableArray alloc] init];
    for (NSManagedObject *obj in array){
        NSDictionary *dict = [obj dictionaryWithValuesForKeys:obj.entity.attributesByName.allKeys];
        NoteModel *model = [[NoteModel alloc] initWithDictionary:dict];
        [result addObject:model];
    }
    return result;
}

-(NSError * _Nullable)editNote:(NSString *_Nonnull)identifier dictionary:(NSDictionary* _Nonnull)dictionary{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
        CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
        
        [manager editData:Note dictionary:dictionary predicate:predicate];
    });
    return nil;
}

-(NSError * _Nullable)deleteNote:(NSString *_Nonnull)identifier{
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];

    [manager deleteData:Note predicate:predicate];
    return nil;
}
@end



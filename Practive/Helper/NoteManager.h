//
//  NoteManager.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import "NoteModel.h"
#import "CoreDataStack.h"
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@interface NoteManager: NSObject

-(NoteModel*)createNote;
-(NSError* _Nullable)saveNote:(NoteModel*)note;
-(NSMutableArray<NoteModel*> *_Nonnull)fetchNotes;
-(NSError * _Nullable)editNote:(NSString *_Nonnull)identifier dictionary:(NSDictionary* _Nonnull)dictionary;
-(NSError * _Nullable)deleteNote:(NSString *_Nonnull)identifier;

@end

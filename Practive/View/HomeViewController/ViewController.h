//
//  ViewController.h
//  Practive
//
//  Created by reyhan muhammad on 15/12/23.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EntityEnum.h"
#import "NoteModel.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIButton * button;
@property (strong, nonatomic) NSMutableArray<NoteModel*> * note;
@property (assign, nonatomic) NSUInteger identifier;
@property (strong, nullable) NoteModel *addedNote;

@end

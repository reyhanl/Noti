//
//  ViewController.m
//  Practive
//
//  Created by reyhan muhammad on 15/12/23.
//

#import "ViewController.h"
#import "NoteTableViewCell.h"
#import "NoteManager.h"
#import "CoreDataManager.h"
#import "CoreDataStack.h"
#import "NoteViewController.h"

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkNewNote];
    [self getCoredata];
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self getCoredata];
    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
//    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
//    [manager deleteDataWithEntity:Note predicate:nil];
    [self setupUI];
//    [self saveNewEntry];
    [self getCoredata];
//    [self addLabel];
    [self addTableView];
    [self addNewNoteButton];
}

-(void)updateUI{
    [self.button setHidden:!(_identifier == 0)];
    [self.navigationItem.rightBarButtonItem setHidden:(_identifier == 0)];
    [self.tableView reloadData];
}

-(void) setupUI{
    self.title = @"Note";
    self.navigationController.navigationBar.prefersLargeTitles = true;
    [self.button setHidden:!(self.identifier == 0)];
    [self.navigationItem.rightBarButtonItem setHidden:(_identifier == 0)];
    [self.tableView reloadData];
}

-(void)checkNewNote{
    if (self.addedNote != nil){
        if ([self.addedNote.body.attributedString.string  isEqual: @""] && [self.addedNote.title isEqual:@""]){
            for (int i = 0;i<self.note.count;i++){
                NoteModel *note = [self.note objectAtIndex:i];
                if ([note.identifier isEqualToString:_addedNote.identifier]){
                    [self deleteRow:i];
                }
            }
        }
        self.addedNote = nil;
    }
}

-(void) addNewNoteButton{
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:button];
    
    [button.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30].active = true;
    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [button.widthAnchor constraintEqualToAnchor:self.view.widthAnchor multiplier:0.8].active = true;
    [button.heightAnchor constraintEqualToConstant:50].active = true;
    button.backgroundColor = UIColor.orangeColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"Add new note" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewNote) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStyleDone target:self action:@selector(addNewNote)];
    
    self.button = button;
}

-(void)addNewNote{
    NoteManager *manager = [[NoteManager alloc] init];
    NoteModel *note = [manager createNote];
    NSError *error = [manager saveNote:note];
    
    if (error == nil){
        NoteModel *newEntry = note;
        [self.tableView beginUpdates];
        [self.note insertObject:newEntry atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        self.addedNote = newEntry;
        [self goToNoteVC:newEntry];
    }
}

-(void)deleteAllRows{
    CoreDataStack *stack = [[CoreDataStack alloc] init:@"Practive"];
    CoreDataManager *manager = [[CoreDataManager alloc] init:stack];
    [manager deleteDataWithEntity:Note predicate:nil];
}

-(void)getCoredata{
    NoteManager *manager = [[NoteManager alloc] init];
    NSMutableArray* array = [manager fetchNotes];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastModified"
                                               ascending:NO];
    NSArray<NoteModel*> *sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];

    self.note = [[NSMutableArray alloc] initWithArray:sortedArray];
    self.identifier = array.count;
    NSLog(@"count: %lu", (unsigned long)array.count);
}

-(void) addLabel{
    CGPoint center  = self.view.center;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(center.x, center.y, 200, 200)];
    NSString * text = @"Reyhab";
    
    label.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:label];
    
    [label.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor].active = true;
    [label.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor constant:10].active = true;
    
    label.backgroundColor = [[UIColor alloc] initWithRed:100 green:0 blue:0 alpha:1];
    label.text = text;
    
    self.label = label;
}

-(void) addTableView{
    UITableView * tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    self.tableView = tableView;
    
    tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:tableView];
    
    [tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    [self.tableView registerClass:NoteTableViewCell.self forCellReuseIdentifier:@"cell"];

    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void) fetchData{
    NSURL * url = [[NSURL alloc] initWithString:@""];
    [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

-(void)goToNoteVC:(NoteModel*)note{
    NoteViewController *vc = [[NoteViewController alloc] init];
    vc.note = note;
    vc.selectedIndex = [note.emotion intValue];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)deleteRow:(NSInteger)index{
    NoteManager *manager = [[NoteManager alloc] init];
    NSString *identifier = [self.note objectAtIndex:index].identifier;
    [manager deleteNote:identifier];
    [self.tableView beginUpdates];
    [self.note removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NoteTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NoteModel *object = [self.note objectAtIndex:indexPath.row];
    [cell setupCell: object];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.note.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *note = [self.note objectAtIndex:indexPath.row];
    [self goToNoteVC:note];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteRow:indexPath.row];
    }];
    UISwipeActionsConfiguration *action = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    return action;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end


//
//  MemeTableViewCell.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface MemeTableViewCell : UITableViewCell

@property (strong, nonatomic) UIStackView * stackView;
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UILabel * descriptionLabel;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIImageView *thumbImageView;
@property (strong, nonatomic) NSArray * memes;


- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCoder:(NSCoder *)coder;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void) setupCell:(nullable NoteModel *)note;

@end

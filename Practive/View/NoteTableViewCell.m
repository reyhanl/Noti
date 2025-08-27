//
//  MemeTableViewCell.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addStackView];
        [self addLabel];
        [self addDescriptionLabel];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addImageView];
        [self addStackView];
        [self addLabel];
        [self addDescriptionLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addImageView];
        [self addStackView];
        [self addLabel];
        [self addDescriptionLabel];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addImageView];
        [self addStackView];
        [self addLabel];
        [self addDescriptionLabel];
    }
    return self;
}

-(void) addLabel{
    self.label = [[UILabel alloc] init];
    [self.stackView addArrangedSubview:_label];
    [self.label setFont:[UIFont boldSystemFontOfSize:14]];
}

-(void) addDescriptionLabel{
    self.descriptionLabel = [[UILabel alloc] init];
    [self.stackView addArrangedSubview:_descriptionLabel];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:12]];
}

-(void) addStackView{
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:stackView];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    
    [stackView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.8].active = true;
    [stackView.heightAnchor constraintGreaterThanOrEqualToConstant:30].active = true;
    [stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10].active = true;
    
    self.stackView = stackView;
}

-(void)addImageView{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:imageView];
    
    [imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10].active = true;
    [imageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = true;
    [imageView.widthAnchor constraintEqualToConstant:self.frame.size.height * 0.8].active = true;
    [imageView.heightAnchor constraintEqualToConstant:self.frame.size.height * 0.8].active = true;
    imageView.layer.cornerRadius = 4;
    imageView.clipsToBounds = true;
    self.thumbImageView = imageView;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = true;
}

-(void) setupCell:(nullable NoteModel *)note{
    self.label.text = [note getTitle];
    self.descriptionLabel.text = [note getBody];
    self.thumbImageView.image = note.getImage;
}

@end

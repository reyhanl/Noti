//
//  EmojiCollectionViewCell.m
//  Practive
//
//  Created by reyhan muhammad on 16/01/24.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addImageView];
    }
    return self;
}

-(void) addImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
//    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [imageView setFrame:self.bounds];
    [self.contentView addSubview:imageView];
//
    [imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = true;
    [imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = true;
    [imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = true;
    [imageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = true;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self layoutIfNeeded];
    self.imageView = imageView;
}

-(void)animateEmoji{
    NSLog(@"clickec");
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint origin = self.imageView.frame.origin;
        CGSize size = self.imageView.frame.size;
        [self.imageView setFrame:CGRectMake(origin.x - (size.width * 2 / 4), origin.y - (size.height * 2 / 4), size.width * 2, size.height * 2)];
    }];
}

-(void)setupCell: (int)emojiID selected:(bool)selected{
    self.imageView.frame = self.imageView.frame;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", emojiID + 1]];
    NSLog(@"%f %f", self.imageView.frame.size.height, self.frame.size.height);
    self.clipsToBounds = false;
}

@end

@implementation ColorCollectionViewCell


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addImageView];
    }
    return self;
}

-(void) addImageView{
    UIView *view = [[UIView alloc]init];
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:view];
    
    [view.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = true;
    [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = true;
    
    self.colorView = view;
}

-(void)animateEmoji{
}

-(void)setupCell: (UIColor*)color selected:(bool)selected{
    _colorView.backgroundColor = color;
}

@end

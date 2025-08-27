//
//  ColorView.m
//  Practive
//
//  Created by reyhan muhammad on 04/02/24.
//

#import "ColorView.h"

@implementation ColorView : UIView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addTapGestureRecognizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTapGestureRecognizer];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTapGestureRecognizer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height / 2;
}

-(void)addTapGestureRecognizer{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectColor)];
    [self setUserInteractionEnabled:true];
    [self addGestureRecognizer:tapGesture];
}

-(void)didSelectColor{
    [self.delegate didSelect:self.color];
}

-(void)setupUI: (UIColor*)color selected:(bool)selected{
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = selected ? 5:3;
    self.color = color;
    self.backgroundColor = color;
}

@end

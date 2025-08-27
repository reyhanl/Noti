//
//  EditableFrame.m
//  Practive
//
//  Created by reyhan muhammad on 26/01/24.
//


#import "EditableFrame.h"

@implementation EditableFrame

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addBottomRightView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBottomRightView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addBottomRightView];
    }
    return self;
}

-(void)addBottomRightView{
    UIImageView *view = [[UIImageView alloc]init];
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:view];
    
    
    CGFloat width = [self getScreenFrame].size.width / 20;
    [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-width].active = true;
    [view.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-width].active = true;
    [view.widthAnchor constraintEqualToConstant:width].active = true;
    [view.heightAnchor constraintEqualToConstant:width].active = true;
    
    view.image = [UIImage imageNamed:@"resizeHandleImageBottomRight"];
    
    [view setUserInteractionEnabled:true];
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleBottomRightGesture:)];
    [view addGestureRecognizer:gesture];
    
    self.bottomRightView = view;
}

-(void)handleTopLeftGesture: (UIPanGestureRecognizer*)gesture{
}
-(void)handleTopRightGesture: (UIPanGestureRecognizer*)gesture{
    
}
-(void)handleBottomLeftGesture: (UIPanGestureRecognizer*)gesture{
    
}
-(void)handleBottomRightGesture: (UIPanGestureRecognizer*)gesture{
    CGPoint translation = [gesture translationInView:self];
    UIView *view = self;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _size = self.frame.size;
            [_bottomRightView setHidden:true];
            [gesture.view setHidden:true];
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"");
            CGFloat newWidth = (_size.width + translation.x);
            CGFloat scale = newWidth / _size.width;
            CGSize newSize = CGSizeMake(newWidth, _size.height * scale);
            self.newSize = newSize;
            [self.delegate resize:newSize];
            break;
        case UIGestureRecognizerStateEnded:
            [self.delegate finishResizing];
            [self removeFromSuperview];
            NSLog(@"called");
        default:
            break;
    }
}

-(CGRect)getScreenFrame{
    if(UIScreen.mainScreen){
        return UIScreen.mainScreen.bounds;
    }else{
        return CGRectMake(0, 0, 0, 0);
    }
    
}

@end

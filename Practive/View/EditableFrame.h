//
//  EditableFrame.h
//  Practive
//
//  Created by reyhan muhammad on 26/01/24.
//

#import <UIKit/UIKit.h>
#import "ResizeAttachmentProtocol.h"

@interface EditableFrame : UIView

@property (strong, nullable) UIView *topLeftView;
@property (strong, nullable) UIView *topRightView;
@property (strong, nullable) UIView *bottomLeftView;
@property (strong, nullable) UIView *bottomRightView;
@property (strong, nullable) NSLayoutConstraint *trailingConstraint;
@property (strong, nullable) NSLayoutConstraint *bottomConstraint;
@property (assign, atomic) CGSize attachmentSize;
@property (assign, atomic) CGSize size;
@property (assign, atomic) CGSize newSize;
@property (weak) id <ResizeAttachmentProtocol> delegate;
-(void)handleTopLeftGesture: (UIPanGestureRecognizer*)gesture;
-(void)handleTopRightGesture: (UIPanGestureRecognizer*)gesture;
-(void)handleBottomLeftGesture: (UIPanGestureRecognizer*)gesture;
-(void)handleBottomRightGesture: (UIPanGestureRecognizer*)gesture;

@end


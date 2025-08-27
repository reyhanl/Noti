//
//  NoteViewController.h
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "NoteManager.h"
#import "ImageModel.h"
#import "ImageManager.h"
#import "EmojiCollectionViewCell.h"
#import "ResizeAttachmentProtocol.h"
#import "AttachmentTapGestureRecognizer.h"
#import "EditableFrame.h"
#import "CustomAttachment.h"
#import "ColorView.h"

@interface NoteViewController:UIViewController<UITextViewDelegate, UIEditMenuInteractionDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIContextMenuInteractionDelegate, ResizeAttachmentProtocol, ColorViewDelegate>

@property (weak, nullable) NoteModel *note;
@property (strong, nullable) UITextView *textView;
@property (strong, nullable) UIScrollView *scrollView;
@property (strong, nullable) UIView *containerView;
@property (strong, nullable) UIStackView *stackView;
@property (atomic, assign) int selectedIndex;
@property (atomic, assign) int currentContentOffset;
@property (atomic, assign) CGFloat fontSize;
@property (strong, nullable) CustomAttachment *editedAttachment;
@property (strong, nullable) NSArray<UIColor*> *colors;
@property (atomic, assign) NSRange selectedRange;
@property (strong) NSLayoutConstraint *colorViewBottomConstraint;
@property (strong) NSTextStorage *textStorage;
@property (atomic, nullable) NSTimer *timer;
@property (assign) bool shouldShowColorView;

@end

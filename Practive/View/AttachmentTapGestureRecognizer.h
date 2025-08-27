//
//  AttachmentTapGestureRecognizer.h
//  Practive
//
//  Created by reyhan muhammad on 26/01/24.
//

#import <UIKit/UIKit.h>


@interface AttachmentTapGestureRecognizer : UIGestureRecognizer
@property (assign, atomic) int attachmentCharacterIndex;
@property (strong, nullable) NSTextAttachment *attachment;
@end

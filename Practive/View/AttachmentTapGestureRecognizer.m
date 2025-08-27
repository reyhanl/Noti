//
//  ResizeableImageView.m
//  Practive
//
//  Created by reyhan muhammad on 26/01/24.
//

#import "AttachmentTapGestureRecognizer.h"

@implementation AttachmentTapGestureRecognizer

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.attachment = nil;
    
    UITextView *textView = (UITextView*)self.view;
    if (touches.count == 1) {
        UITouch *touch = touches.allObjects.firstObject;
        if( touch && touch.tapCount == 1){
            CGPoint point = [touch locationInView:textView];
            int glyphIndex = (int)[textView.layoutManager glyphIndexForPoint:point inTextContainer:textView.textContainer fractionOfDistanceThroughGlyph:nil];
            CGRect glyphRect = [textView.layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:textView.textContainer];
            int index = (int)[textView.layoutManager characterIndexForGlyphAtIndex:glyphIndex];
            if (index < textView.textStorage.length && CGRectContainsPoint(glyphRect, point)){
                if (NSAttachmentCharacter == [(NSString*)textView.textStorage.string characterAtIndex:index]) {
                    _attachmentCharacterIndex = index;
                    self.attachment = [textView.textStorage attribute:NSAttachmentAttributeName atIndex:index effectiveRange:0];
                    self.state = UIGestureRecognizerStateRecognized;
                } else {
                    self.state = UIGestureRecognizerStateFailed;
                }
            }else{
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}
@end

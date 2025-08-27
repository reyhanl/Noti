//
//  NoteViewController.m
//  Practive
//
//  Created by reyhan muhammad on 09/01/24.
//

#import <Foundation/Foundation.h>
#include "NoteViewController.h"
#import "UIColorExtension.h"

@interface UITextView (MyExtension)
-(void)add:(AttachmentTapGestureRecognizer*)attachmentRecognizer;
@end

@implementation UITextView (MyExtension)
-(void)add: (AttachmentTapGestureRecognizer*)attachmentRecognizer {
    for (UIGestureRecognizer *gesture in self.gestureRecognizers){
        [gesture requireGestureRecognizerToFail:attachmentRecognizer];
        [self addGestureRecognizer:attachmentRecognizer];
    }
}
@end


@implementation NoteViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    [self setupView];
    self.fontSize = 14;
    self.shouldShowColorView = true;
    [self addScrollView];
    [self addContainerView];
    [self addTextView];
    [self addImageButton];
    [self addEmojiCollectionView];
    [self addKeyboardObserver];
    [self setColor];
    [self populateStackView];
    [self updateUI];
}

-(void)setupView{
    UIColor *color = [UIColor whiteColor];
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        color = [UIColor blackColor];
    }else{
        color = [UIColor whiteColor];
    }
    self.view.backgroundColor = color;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObserver];
}

- (void)viewDidDisappear:(BOOL)animated{
    if ([self.note.body.attributedString.string  isEqual: @""]){
        NoteManager *manager = [[NoteManager alloc] init];
        [manager deleteNote:self.note.identifier];
    }
}

- (void)dealloc
{
    [self removeObserver];
}

-(void)addKeyboardObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(keyboardShows:)
                    name:UIKeyboardDidShowNotification
                    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                    selector:@selector(keyboardHide:)
                    name:UIKeyboardWillHideNotification
                    object:nil];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardShows:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.colorViewBottomConstraint.constant = -keyboardFrameBeginRect.size.height - 10;
    [self.view layoutIfNeeded];
}

- (void)keyboardHide:(NSNotification*)notification
{
    self.colorViewBottomConstraint.constant = -10;
    [self.view layoutIfNeeded];
}

//MARK: SetupUI

-(void) addContainerView{
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self.scrollView addSubview: view];
    
    [view.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor].active = true;
    [view.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = true;
    [view.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = true;
    [view.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.scrollView.bottomAnchor].active = true;
    [view.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor].active = true;
    [view.heightAnchor constraintGreaterThanOrEqualToConstant:self.view.frame.size.height].active = true;
    
    self.containerView = view;
}

-(void) addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    [scrollView setAlwaysBounceVertical:true];
    
    self.scrollView = scrollView;
}

-(void) addTextView{
    UITextView *textView = [[UITextView alloc] init];
    textView.delegate = self;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.translatesAutoresizingMaskIntoConstraints = false;
    [textView setFont: [UIFont systemFontOfSize:self.fontSize]];
    [self.containerView addSubview:textView];
    
    [textView.heightAnchor constraintEqualToAnchor:_containerView.heightAnchor].active = true;
    [textView.widthAnchor constraintEqualToAnchor:_containerView.widthAnchor].active = true;
    [textView setScrollEnabled:false];
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        textView.textColor = [UIColor whiteColor];
    }else{
        textView.textColor = [UIColor blackColor];
    }
    
    AttachmentTapGestureRecognizer *gesture = [[AttachmentTapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectAttachment:)];
    [textView add:gesture];
    
    self.textView = textView;
}

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self.textView attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self.textView bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];

    NSRange glyphRange;

    // Convert the range for glyphs.
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];

    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

-(void)addImageButton{
    UIImageView *item = [[UIImageView alloc]init];
    item.image = [UIImage imageNamed:@"addMediaImage"];
    item.translatesAutoresizingMaskIntoConstraints = false;
    [item.heightAnchor constraintEqualToConstant:self.navigationController.navigationBar.frame.size.height / 3].active = true;
    [item.widthAnchor constraintEqualToConstant:self.navigationController.navigationBar.frame.size.height / 3].active = true;
    [item setUserInteractionEnabled:true];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentImagePicker)];
    [item addGestureRecognizer:gesture];
    [item setContentMode: UIViewContentModeScaleAspectFit];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:item];
    self.navigationItem.rightBarButtonItem =        barItem;
}

-(void)addEmojiCollectionView{
    UIStackView *view = [[UIStackView alloc] initWithFrame:self.view.frame];
        
    view.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:view];
    self.colorViewBottomConstraint = [view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10];
    self.colorViewBottomConstraint.active = true;
    [view.widthAnchor constraintGreaterThanOrEqualToAnchor:self.view.widthAnchor multiplier:0.1].active = true;
    [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [view.heightAnchor constraintEqualToConstant:50].active = true;
    view.axis = UILayoutConstraintAxisHorizontal;
    view.spacing = 10;

    self.stackView = view;
}

-(void)populateStackView{
    for (UIColor *color in _colors){
        [self generateView:color];
    }
}

-(void)generateView: (UIColor*)color{
    ColorView *view = [[ColorView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = false;
    view.backgroundColor = color;
    [view setupUI:color selected:false];
    view.delegate = self;
    [self.stackView addArrangedSubview:view];
    
    [view.widthAnchor constraintEqualToConstant:50].active = true;
    [view.heightAnchor constraintEqualToConstant:50].active = true;
}

-(void)dismissKeyboard:(UITapGestureRecognizer*)gesture{
    if ([gesture.view isKindOfClass:[UITextView class]]){
        UITextView *view = (UITextView*)gesture.view;
        [view becomeFirstResponder];
    }else{
        [self.view endEditing:true];
    }
}

-(void)panGesture:(UIPanGestureRecognizer*)panGesture {
    CGPoint translation = [panGesture translationInView:self.view];
    NSLog(@"x: %f, y: %f", translation.x, translation.y);
}

//MARK: TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.location == 0 && [text  isEqual: @""]){
        return true;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    
    NSLog(@"Original text: '%@'", text);
    NSLog(@"Final attributed string: '%@'", attrString.string);

    UIColor *color = [UIColor blackColor];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        color = [UIColor whiteColor];
    }else{
        color = [UIColor blackColor];
    }
    [attrString replaceCharactersInRange:range withString:text];
    NSDictionary *attrs = @{
        NSForegroundColorAttributeName: color,
        NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]
    };
    if (range.location + text.length <= attrString.length) {
        [attrString setAttributes:attrs range:NSMakeRange(range.location, text.length)];
    }
    if (range.location + range.length <= attrString.length){
        [attrString addAttributes:attrs range:NSMakeRange(range.location, 1)];
    }
    self.shouldShowColorView = false;
    
    _textView.attributedText = attrString;
    if([text isEqual:@""]){
        _textView.selectedRange = NSMakeRange(range.location, 0);
    }else{
        _textView.selectedRange = NSMakeRange(range.location + text.length, 0);
    }
    self.note.body.attributedString = attrString;
    [self save];
    self.shouldShowColorView = true;
    return false;
}

- (UIMenu *)textView:(UITextView *)textView editMenuForTextInRange:(NSRange)range suggestedActions:(NSArray<UIMenuElement *> *)suggestedActions{
    __block UIAction *boldAction;
    __block UIAction *italicAction;
    
    Boolean isDarkMode = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    UIColor *color = isDarkMode ? [UIColor whiteColor]:[UIColor blackColor];
    
    UIImage *ttImage = [[UIImage imageNamed:@"TT"] imageWithTintColor:color];
    
    UIAction *titleAction = [UIAction actionWithTitle:@"" image:ttImage identifier:nil handler:^(UIAction * _Nonnull action) {
        NSAttributedString *attrString = [self titledText:range];
        [self saveAndUpdate:attrString];
    }];
    
    
    if ([self isBold:range]){
        boldAction = [UIAction actionWithTitle:@"B" image:nil identifier:nil handler:^(UIAction * _Nonnull action) {
            NSAttributedString *attrString = [self boldText:range];
            [self saveAndUpdate:attrString];
        }];
    }else{
        UIImage *boldImage = [[UIImage imageNamed:@"B"] imageWithTintColor:color];
        boldAction = [UIAction actionWithTitle:@"" image:boldImage identifier:nil handler:^(UIAction * _Nonnull action) {
            NSAttributedString *attrString = [self boldText:range];
            [self saveAndUpdate:attrString];
        }];
    }
   
        
    if ([self isItalic:range]){
        italicAction = [UIAction actionWithTitle:@"i" image:nil identifier:nil handler:^(UIAction * _Nonnull action) {
            NSAttributedString *attrString = [self italicText:range];
            [self saveAndUpdate:attrString];
        }];
    }else{
        UIImage *italicImage = [[UIImage imageNamed:@"i"] imageWithTintColor:color];

        italicAction = [UIAction actionWithTitle:@"" image:italicImage identifier:nil handler:^(UIAction * _Nonnull action) {
            NSAttributedString *attrString = [self italicText:range];
            [self saveAndUpdate:attrString];
        }];
    }

    self.selectedRange = range;
    // Create and return a UIMenu with the "Bold" action
    return [UIMenu menuWithTitle:@"" children:@[titleAction, boldAction, italicAction]];
}


- (void)textViewDidChangeSelection:(UITextView *)textView{
   UITextRange *selectedRange = [textView selectedTextRange];
   NSString *selectedText = [textView textInRange:selectedRange];
    NSLog(@"selectedText: %@", selectedText);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    if(!self.shouldShowColorView){
        [_stackView setHidden:true];
        return;
    }
    if (_selectedRange.location != NSNotFound &&
        NSMaxRange(_selectedRange) < attrString.length &&
        selectedText.length > 0) {

        NSDictionary<NSAttributedStringKey, id> *attributes =
            [attrString attributesAtIndex:_selectedRange.location effectiveRange:nil];

        UIColor *temp = attributes[NSForegroundColorAttributeName];

        for (ColorView *view in _stackView.arrangedSubviews) {
            if ([view.color isEqual:temp]) {
                [view setupUI:temp selected:YES];
            } else {
                [view setupUI:view.color selected:NO];
            }
        }

        _stackView.hidden = NO;
    } else {
        _stackView.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *_Nonnull)textView{
    NSString *title = [self getTitle:textView.text];
    NSLog(@"title: %@", title);
    self.note.title = title;
    [self titleText];
    self.note.body.attributedString = textView.attributedText;
    [self save];
}

-(void) updateUI{
    [self loadText];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

-(void)loadText{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.note.body.attributedString];
    [attrString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if ([value isKindOfClass:[CustomAttachment class]]) {
            NSTextAttachment *attachment = (NSTextAttachment *)value;
            CustomAttachment *temp = (CustomAttachment*)attachment;
            attachment.bounds = CGRectMake(0, 0, temp.originalSize.width, temp.originalSize.height);
            NSLog(@"size: %@", NSStringFromCGSize(temp.originalSize));
            NSAttributedString *newAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            [attrString replaceCharactersInRange:range withAttributedString:newAttachmentString];
            
        }
    }];
    self.note.body.attributedString = attrString;
    self.textView.attributedText = attrString;
}

-(NSString *_Nonnull)getTitle: (NSString*_Nonnull)title{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    NSUInteger len = [title length];
    unichar buffer[len+1];
    
    [title getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSLog(@"getCharacters:range: with unichar buffer");
    for(int i = 0; i < len; i++) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        if ([charString  isEqual: @"\n"]){
            break;
        }
        [result appendString:charString];
        
        NSLog(@"%C", buffer[i]);
    }
    return result;
}

-(NSString *_Nonnull)getBody: (NSString*_Nonnull)title{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    NSUInteger len = [title length];
    unichar buffer[len+1];
    
    [title getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSLog(@"getCharacters:range: with unichar buffer");
    bool isBody = false;
    for(int i = 0; i < len; i++) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        if ([charString  isEqual: @"\n"]){
            isBody = true;
        }
        if (isBody){
            [result appendString:charString];
        }
    }
    return result;
}

-(void)save{
//    self.timer = nil;
//    self.timer = [NSTimer timerWithTimeInterval:0.2 repeats:false block:^(NSTimer * _Nonnull timer) {
        NSDictionary *dict = [self.note dictionaryRepresantation];
        NoteManager *manager = [[NoteManager alloc] init];
        [manager editNote:self.note.identifier dictionary:dict];
//    }];
}

-(void)titleText{
    UITextView *textView = self.textView;
    if (textView.text.length == 0){
        return;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    NSRange breakRange = [textView.text rangeOfString:@"\n"];
    NSRange titleRange = NSMakeRange(0, 0);
    if (breakRange.location == NSNotFound){
        titleRange = NSMakeRange(0, textView.text.length);
    }else{
        titleRange = NSMakeRange(0, breakRange.location + breakRange.length);
    }
    titleRange.location = 0;
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:titleRange];
    if (breakRange.location != NSNotFound){
        NSRange range = NSMakeRange(breakRange.location + breakRange.length - 1, textView.text.length - breakRange.location);
        NSLog(@"startingRange: %lu, %lu", range.location, range.location + range.length);
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    }
    [attrString endEditing];
    textView.attributedText = attrString;
}

-(bool)validTag:(NSString*)str index:(int *_Nonnull)index identifier: (NSString**)identifier range:(NSRange*)range{
    NSMutableString *result = [NSMutableString stringWithString:@""];
    NSUInteger len = [str length];
    unichar buffer[len+1];
    
    [str getCharacters:buffer range:NSMakeRange(0, len)];
    
    int count = 0;
    bool validTag = false;
    NSLog(@"getCharacters:range: with unichar buffer");
    
    for(int i = *index; i < len; i++) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        count += 1;
        [result appendString:charString];
        if ([charString  isEqual: @">"]){
            bool match = [self checkImgTag:result identifier:identifier];
            if (match){
                int tempIndex = *index;
                *range = NSMakeRange(tempIndex, i - tempIndex);
                //Add a lot of \n to accomodate for the image
                *index += count;
            }
            return match;
            
        }
        NSLog(@"%C", buffer[i]);
    }
    return validTag;
}

-(bool)checkImgTag: (NSString*)str identifier:(NSString**)identifier{
    NSString *pattern = @"<img id:\"([^\"]+)\">";
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        NSLog(@"Error creating regular expression: %@", [error localizedDescription]);
        return false;
    }
    
    NSRange searchRange = NSMakeRange(0, str.length);
    NSTextCheckingResult *match = [regex firstMatchInString:str options:0 range:searchRange];
    if (match){
        NSRange idRange = [match rangeAtIndex:1];
        *identifier = [str substringWithRange:idRange];
        NSLog(@"id: %@", *identifier);
        return true;
    }else{
        return false;
    }
}


-(void)addText{
    ImageManager *manager = [[ImageManager alloc] init];
    NSString *identifier = [[NSUUID alloc] init].UUIDString;
    NSString *imgTag = [[NSString alloc] initWithFormat:@" %@", identifier];
    [self save];
}

-(void)addImage: (UIImage*)image at:(int)index{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    CustomAttachment *textAttachment = [[CustomAttachment alloc] init];
    textAttachment.image = image;
    
    CGFloat oldWidth = textAttachment.image.size.width;
    
    //I'm subtracting 10px to make the image display nicely, accounting
    //for the padding inside the textView
    CGFloat scaleFactor = oldWidth / (_textView.frame.size.width - 10);
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:self.textView.selectedRange withAttributedString:attrStringWithImage];
    _textView.attributedText = attributedString;
    self.note.body.attributedString = attributedString;

    [self save];
}

-(void)presentImagePicker{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentModalViewController:picker animated:true];
}

-(bool) isValidImageTag: (int)index range:(NSRange*)range{
    NSString *str = self.note.body.attributedString;
    NSUInteger len = str.length;
    unichar buffer[len+1];
    [str getCharacters:buffer range:NSMakeRange(0, len)];
    bool isValidTag = false;
    for(int i = index; i > 0; i--) {
        unichar character = buffer[i];
        NSString *charString = [NSString stringWithFormat:@"%c", character];
        if ([charString  isEqual: @"<"]){
            NSString *identifier = nil;
            isValidTag = [self validTag:str index:&i identifier: &identifier range:range];
            return isValidTag;
        }
    }
    return false;
}

-(int)getIndex: (int)index{
    return 0;
}

-(void) addBoldButton{
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:button];
    
    [button.topAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [button.heightAnchor constraintEqualToConstant:90].active = true;
    [button.widthAnchor constraintEqualToConstant:90].active = true;
    
    [button addTarget:self action:@selector(boldText) forControlEvents:UIControlEventTouchUpInside];
}

//MARK: Font Attribute Manipulation

-(void)setColor{
    UIColor *black = [UIColor blackColor];
    UIColor *blackDarkColor = black.dark;
    
    UIColor *white = [UIColor whiteColor];
    UIColor *whiteDarkColor = black.dark;
    
    UIColor *blue = [UIColor blueColor];
    UIColor *blueDarkColor = blue.dark;
    
    UIColor *brown = [UIColor brownColor];
    UIColor *brownDarkColor = brown.dark;
    
    UIColor *yellow = [UIColor yellowColor];
    UIColor *yellowDarkColor = yellow.dark;
    
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        self.colors = @[white, blue, brown, yellow];
    }else{
        self.colors = @[black, blue, brown, yellow];
    }
}

-(void)boldText{
    NSRange range = _textView.selectedRange;
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attrString = self.textView.attributedText;
    UIFont *font = [[UIFont alloc] init];
    
    [mutableString insertAttributedString:attrString atIndex:0];
    NSDictionary *attributes = [attrString attributesAtIndex:range.location effectiveRange:&range];
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];
    
    NSLog(@"attributes: %@", attributes);
    
    [mutableString beginEditing];
    [mutableString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    [mutableString endEditing];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        [self dismissViewControllerAnimated:true completion:^{
            if (self.textView.selectedRange.location){
                int index = (int)self.textView.selectedRange.location;
                [self addImage:pickedImage at:index];
            }else{
                int index = (int)self.textView.selectedRange.location;
                [self addImage:pickedImage at:(int)self.textView.text.length - 1];
            }
        }];
    }
    
}

-(NSAttributedString*)italicText: (NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block BOOL isRangeBold = NO;
    __block UIFont *tempFont;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
       
        tempFont = font;
        isRangeBold = [[font fontName] containsString:@"italic"];
    }];
    UIFontDescriptor *fontDescriptor = tempFont.fontDescriptor;
    uint32_t traits = [fontDescriptor symbolicTraits];
    
    if ((traits & (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) == (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) {
        UIFontDescriptor * nonBoldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits & ~UIFontDescriptorTraitItalic)];
        tempFont = [UIFont fontWithDescriptor:nonBoldDescriptor size:fontDescriptor.pointSize];
    } else if (traits & UIFontDescriptorTraitItalic){
        UIFontDescriptor * nonItalicDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits & ~UIFontDescriptorTraitItalic)];
        tempFont = [UIFont fontWithDescriptor:nonItalicDescriptor size:fontDescriptor.pointSize];
    } else if (traits & UIFontDescriptorTraitBold){
        UIFontDescriptor * boldItalicDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits | UIFontDescriptorTraitItalic)];
        tempFont = [UIFont fontWithDescriptor:boldItalicDescriptor size:fontDescriptor.pointSize];
    }else {
        UIFontDescriptor *italicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        tempFont = [UIFont fontWithDescriptor:italicFontDescriptor size:fontDescriptor.pointSize];
    }
    
    [attrString addAttributes:@{
            NSFontAttributeName: tempFont
    } range:range];

    return attrString;
}

-(NSAttributedString*)boldText: (NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block BOOL isRangeBold = NO;
    __block UIFont *tempFont;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
       
        tempFont = font;
        isRangeBold = [[font fontName] containsString:@"bold"];
    }];
    UIFontDescriptor *fontDescriptor = tempFont.fontDescriptor;
    uint32_t traits = [fontDescriptor symbolicTraits];
    
    if ((traits & (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) == (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) {
        UIFontDescriptor * nonBoldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits & ~UIFontDescriptorTraitBold)];
        tempFont = [UIFont fontWithDescriptor:nonBoldDescriptor size:fontDescriptor.pointSize];
    } else if (traits & UIFontDescriptorTraitBold){
        UIFontDescriptor * nonBoldDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits & ~UIFontDescriptorTraitBold)];
        tempFont = [UIFont fontWithDescriptor:nonBoldDescriptor size:fontDescriptor.pointSize];
    } else if (traits & UIFontDescriptorTraitItalic){
        UIFontDescriptor *boldItalicDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:(fontDescriptor.symbolicTraits | UIFontDescriptorTraitItalic | UIFontDescriptorTraitBold)];
        tempFont = [UIFont fontWithDescriptor:boldItalicDescriptor size:fontDescriptor.pointSize];
    }else {
        UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        tempFont = [UIFont fontWithDescriptor:boldFontDescriptor size:fontDescriptor.pointSize];
    }
    
    [attrString addAttributes:@{
            NSFontAttributeName: tempFont
    } range:range];

    return attrString;
}

-(NSAttributedString*)titledText:(NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block UIFont *tempFont;
    __block CGFloat fontSize;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
        
        tempFont = font;
    }];
    fontSize = tempFont.pointSize > self.fontSize ? self.fontSize:24;
    [attrString beginEditing];
    UIFont *font = tempFont.pointSize > self.fontSize ? [UIFont systemFontOfSize:fontSize]:[UIFont boldSystemFontOfSize:fontSize];
    [attrString addAttribute:NSFontAttributeName value:font range:range];
    [attrString endEditing];
    return attrString;
}

-(bool)isBold:(NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block UIFont *tempFont;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
       
        tempFont = font;
    }];
    UIFontDescriptor *fontDescriptor = tempFont.fontDescriptor;
    uint32_t traits = [fontDescriptor symbolicTraits];
    
    if ((traits & (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) == (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) {
        return true;
    } else if (traits & UIFontDescriptorTraitBold){
        return true;
    } else if (traits & UIFontDescriptorTraitItalic){
        return false;
    }else {
        return false;
    }
}

-(bool)isTitled:(NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block UIFont *tempFont;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
       
        tempFont = font;
    }];
    if (tempFont.pointSize > self.fontSize){
        return true;
    }else{
        return false;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    for(UIView* view in self.containerView.subviews){
        if([view isKindOfClass: [EditableFrame class]]){
            [view removeFromSuperview];
        }
    }
}

-(bool)isItalic:(NSRange)range{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    __block UIFont *tempFont;
    [attrString enumerateAttribute:NSFontAttributeName inRange:range options:0 usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
       
        tempFont = font;
    }];
    UIFontDescriptor *fontDescriptor = tempFont.fontDescriptor;
    uint32_t traits = [fontDescriptor symbolicTraits];
    
    if ((traits & (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) == (UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)) {
        return true;
    } else if (traits & UIFontDescriptorTraitBold){
        return false;
    } else if (traits & UIFontDescriptorTraitItalic){
        return true;
    }else {
        return false;
    }
}

-(BOOL)isFontBold:(UIFont*)font
{
    UIFontDescriptor *fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    return isBold;
}

-(void)colorText:(UIColor*)color{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    NSDictionary<NSAttributedStringKey, id> *attributes = [attrString attributesAtIndex:_selectedRange.location effectiveRange:0];
    UIColor *temp = (UIColor*)[attributes objectForKey:NSForegroundColorAttributeName];
    if (temp){
        if (temp == color){
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:self.selectedRange];
        }else{
            [attrString addAttribute:NSForegroundColorAttributeName value:color range:self.selectedRange];
        }
    }else{
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:self.selectedRange];
    }
    [self saveAndUpdate:attrString];
}


-(void)saveAndUpdate:(NSAttributedString*)attrString{
    self.note.body.attributedString = attrString;
    self.textView.attributedText = attrString;
    [self save];
}

- (void)resize:(CGSize)size{
    NSTextStorage *storage = self.textView.textStorage;
    [storage beginEditing];
    [storage enumerateAttribute:NSAttachmentAttributeName
                        inRange:NSMakeRange(0, storage.length)
                        options:0
                     usingBlock:^(id value, NSRange range, BOOL *stop) {
        if ([value isKindOfClass:[CustomAttachment class]]) {
            CustomAttachment *attachment = (CustomAttachment *)value;
            if (attachment == _editedAttachment) {
                attachment.originalSize = size;
                attachment.bounds = CGRectMake(0, 0, size.width, size.height);
                [storage removeAttribute:NSAttachmentAttributeName range:range];
                [storage addAttribute:NSAttachmentAttributeName value:attachment range:range];
                *stop = YES;
            }
        }
    }];
    self.textStorage = storage;
    [storage endEditing];
}

-(void)finishResizing{
    [self save];
}

//MARK: ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < self.currentContentOffset){
        [self.view endEditing:true];
    }
    self.currentContentOffset = scrollView.contentOffset.y;
    [_stackView setHidden:true];
}

//MARK: UICollectionView Delegate & Datasource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//MARK: Custom Delegate
-(void)didSelectAttachment: (AttachmentTapGestureRecognizer*)gesture{
    NSRange range = NSMakeRange(gesture.attachmentCharacterIndex, 1);
    self.editedAttachment = (CustomAttachment*)gesture.attachment;
    CGRect rect = [self boundingRectForCharacterRange:range];
    EditableFrame *view = [[EditableFrame alloc]initWithFrame:rect];
    view.delegate = self;
    //get global position
    [self.containerView addSubview:view];
    NSLog(@"managed to tap attachment");
}

- (void)didSelect:(UIColor *)color{
    [self colorText:color];
}

@end

@interface CustomTextView: UITextView

@end

@implementation CustomTextView

- (void)setSelectedRange:(NSRange)selectedRange{
    NSLog(@"%lu", selectedRange.location);
}

@end

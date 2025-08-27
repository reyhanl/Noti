//
//  EmojiCollectionViewCell.h
//  Practive
//
//  Created by reyhan muhammad on 16/01/24.
//

#import <UIKit/UIKit.h>

@interface EmojiCollectionViewCell : UICollectionViewCell

@property (strong, nullable) UIImageView *imageView;

-(void)setupCell: (int)emojiID selected:(bool)selected;
-(void)animateEmoji;
@end

@interface ColorCollectionViewCell : UICollectionViewCell

@property (strong, nullable) UIView *colorView;

-(void)setupCell: (UIColor*)emojiID selected:(bool)selected;
-(void)animateEmoji;
@end

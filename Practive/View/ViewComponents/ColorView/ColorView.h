//
//  ColorView.h
//  Practive
//
//  Created by reyhan muhammad on 04/02/24.
//

#import <UIKit/UIKit.h>
#import "ColorViewDelegate.h"

@interface ColorView : UIView

@property (weak) id <ColorViewDelegate> delegate;
@property (weak) UIColor* color;

-(void)setupUI: (UIColor*)color selected:(bool)selected;

@end



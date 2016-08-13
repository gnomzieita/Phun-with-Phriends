//
//  MyLabel.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 29.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "MyLabel.h"

@implementation UILabel (MyLabel)

- (void) setStrokeText:(NSString *)text
{
    NSDictionary *typingAttributes = @{
                                       NSFontAttributeName: [UIFont fontWithName:@"CarterOne" size:17.0f],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSStrokeColorAttributeName : [UIColor blackColor],
                                       NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-5.0]
                                       };
    
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:NSLocalizedString(text,text)
                               attributes:typingAttributes];
    
    [self setAttributedText:str];
}

@end

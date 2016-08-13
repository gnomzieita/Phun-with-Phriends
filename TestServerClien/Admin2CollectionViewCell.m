//
//  Admin2CollectionViewCell.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 26.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "Admin2CollectionViewCell.h"

#import "MyLabel.h"

@implementation Admin2CollectionViewCell

- (void) initCell
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settings_sync_cell)
                                                 name:@"settings_sync_cell"
                                               object:nil];
    [self settings_sync_cell];
    
    [_fullDeskLabel setStrokeText:NSLocalizedString(@"Full Desk",@"Full Desk")];
    [_cardsTitle setStrokeText:NSLocalizedString(@"Cards:",@"Cards:")];
    [_cardLabel setStrokeText:NSLocalizedString(@"3 Cards",@"3 Cards")];
    
}

- (void) settings_sync_cell
{
    for (UIButton* bt in _buttons) {
        if (bt.tag == [_delegat getCard_type]) {
            [bt setSelected:NO];
        }
        else
        {
            [bt setSelected:YES];
        }
    }
}
- (IBAction)buttonTap:(id)sender
{
    for (UIButton* bt in _buttons) {
        if (bt == (UIButton*)sender) {
            [bt setSelected:NO];
            [_delegat setCard_type:((UIButton*)sender).tag];
        }
        else
        {
            [bt setSelected:YES];
        }
    }
}

@end

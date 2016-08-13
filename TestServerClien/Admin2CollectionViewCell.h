//
//  Admin2CollectionViewCell.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 26.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsProtocol.h"

@interface Admin2CollectionViewCell : UICollectionViewCell

- (void) initCell;

- (IBAction) buttonTap:(id)sender;

@property (strong, nonatomic) id<SettingsProtocol> delegat;

@property (weak, nonatomic) IBOutlet UILabel *cardsTitle;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *fullDeskLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@end

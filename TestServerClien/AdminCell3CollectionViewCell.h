//
//  AdminCell3CollectionViewCell.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 27.07.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"
#import "SettingsProtocol.h"

@interface AdminCell3CollectionViewCell : UICollectionViewCell

- (void) initCell;


@property (strong, nonatomic) id<SettingsProtocol> delegat;

@property (weak, nonatomic) IBOutlet UILabel *playerOrder;
@property (weak, nonatomic) IBOutlet UILabel *rotating;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *randomArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *roatingArray;

- (IBAction)clockTap:(id)sender;
- (IBAction)randomTap:(id)sender;

- (IBAction)countMinusTap:(id)sender;
- (IBAction)countPlusTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *countLabelInput;

@end

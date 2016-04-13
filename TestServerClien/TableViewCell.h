//
//  TableViewCell.h
//  TestServerClien
//
//  Created by Alex Agarkov on 09.03.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

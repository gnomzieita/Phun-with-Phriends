//
//  GameViewController.h
//  TestServerClien
//
//  Created by Alex Agarkov on 07.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (strong, nonatomic) NSArray* cardArray;
-(void) gameInitNotification:(NSNotification *) notification;
@end

//
//  WaitStartViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 12.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "WaitStartViewController.h"
#import "SelectStartCellViewController.h"
#import "AdminViewController.h"

@interface WaitStartViewController ()

@end

@implementation WaitStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameStart"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotif:)
                                                 name:@"gameInit"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameInitNotif:(NSNotification *) notification
{
    if ([[[notification userInfo] objectForKey:@"admin"] boolValue])
    {
        AdminViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
    }
}

-(void) gameInitNotification
{
    SelectStartCellViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectStartCellViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

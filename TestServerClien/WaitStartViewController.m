//
//  WaitStartViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 12.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "WaitStartViewController.h"
#import "SelectStartCellViewController.h"

@interface WaitStartViewController ()

@end

@implementation WaitStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameStart"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameInitNotification
{
    SelectStartCellViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectStartCellViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

@end

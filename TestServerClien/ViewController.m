//
//  ViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "ViewController.h"
#import "GameCardView.h"
#import "GameViewController.h"
#import "WCScanViewController.h"

@interface ViewController ()

@property (strong, nonatomic) API* myAPI;

@property (weak, nonatomic) IBOutlet UITextField *nikPole;


- (IBAction)startTab:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"back"
                                               object:nil];
     _myAPI = [API sharedController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) gameInitNotification
{
    GameViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}
- (IBAction)startTab:(id)sender
{
    if (_nikPole.text.length>0)
    {
        [_myAPI setUserName:_nikPole.text];
        WCScanViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WCScanViewController"];
        
        [self presentViewController:viewController animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
    }
    else
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error!!" message:@"Введите имя пользователя" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_nikPole resignFirstResponder];
        }];
        [alertController addAction:okAction];
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alertController
                                                         popoverPresentationController];
        popPresenter.sourceView = _nikPole;
        popPresenter.sourceRect = _nikPole.bounds;
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

@end

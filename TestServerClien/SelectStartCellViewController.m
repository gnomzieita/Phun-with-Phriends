//
//  SelectStartCellViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 12.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "SelectStartCellViewController.h"
#import "API.h"
#import "GameViewController.h"

@interface SelectStartCellViewController ()<UIActionSheetDelegate>
{
    API *myAPI;
    UIButton* tapButton;
}

- (IBAction)buttonTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *kub;

@end

@implementation SelectStartCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft]
                                forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    myAPI = [API sharedController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification:)
                                                 name:@"gameAction"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameError)
                                                 name:@"gameError"
                                               object:nil];
//    float h = (_kub.frame.size.height+_kub.frame.size.width)/12;
//    for (int x = 0; x<6; x++) {
//        for (int y=0; y<6; y++) {
//            UIView* kubViev = [[UIView alloc] initWithFrame:CGRectMake(h*x, h*y, h, h)];
//            kubViev.layer.borderWidth = 1;
//            kubViev.layer.borderColor = [UIColor blackColor].CGColor;
//            [_kub addSubview:kubViev];
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) gameError
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:@"Данный путь занят"
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Ясно и понятно))"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                
                                                          }]; // 2
    
    [alert addAction:firstAction]; // 4
    [alert setModalPresentationStyle:UIModalPresentationPopover];
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonTap:(id)sender
{
    tapButton = (UIButton*)sender;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выбор стартовой точки."
                                                                   message:@"Откуда вы хотите начать?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Начать с 1"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                              NSInteger doorNum = tapButton.tag<7?1:(tapButton.tag<13?3:(tapButton.tag<19?5:7));
                                                              [myAPI selectCell:tapButton.tag path:doorNum];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Начать с 2"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSInteger doorNum = tapButton.tag<7?2:(tapButton.tag<13?4:(tapButton.tag<19?6:8));
                                                               [myAPI selectCell:tapButton.tag path:doorNum];
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

-(void) gameInitNotification:(NSNotification *) notification {
    GameViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    [self presentViewController:viewController animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

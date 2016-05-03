//
//  AdminViewController.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 27.04.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "AdminViewController.h"
#import "SelectStartCellViewController.h"
#import "API.h"

@interface AdminViewController ()
{
    NSInteger game_type;
    NSInteger parking_count;
    NSInteger card_type;
    NSInteger rotate_count;
    NSInteger rotate_vector;
    API* myAPI;
}

@property (weak, nonatomic) IBOutlet UIButton *button_1;
@property (weak, nonatomic) IBOutlet UIButton *button_2;
@property (weak, nonatomic) IBOutlet UIButton *button_3;
@property (weak, nonatomic) IBOutlet UIButton *button_4;
@property (weak, nonatomic) IBOutlet UIButton *button_5;

@property (weak, nonatomic) IBOutlet UISwitch *swich;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startButtonTap:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h_b_2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_b_2;

- (IBAction)button_1_tap:(id)sender;
- (IBAction)button_2_tap:(id)sender;
- (IBAction)button_3_tap:(id)sender;
- (IBAction)button_4_tap:(id)sender;
- (IBAction)button_5_tap:(id)sender;

@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [API sharedController];
    _h_b_2.constant = 0;
    _height_b_2.constant = 0;
    
    game_type = 0;
    [_button_1 setTitle:@"Классическая" forState:UIControlStateNormal];

    [_button_3 setTitle:@"вся колода" forState:UIControlStateNormal];
    card_type = 0;
    [_button_4 setTitle:@"0" forState:UIControlStateNormal];
    rotate_count = 0;
    [_button_5 setTitle:@"по часовой" forState:UIControlStateNormal];
    rotate_vector = 0;
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameStart"
                                               object:nil];
    _startButton.layer.cornerRadius = 10.f;
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

- (void) hideShowButton
{
    if (_h_b_2.constant == 0) {
        _h_b_2.constant = 13;
        _height_b_2.constant = 30;
    }
    else
    {
        [UIView animateWithDuration:1 animations:^{
            _h_b_2.constant = 0;
            _height_b_2.constant = 0;
        }];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}



/*
 user_shuffle = false – игроки расставлены по порядку подключения
 user_shuffle = true – перемешиваются
 */
/*
 rotate_count = 0 – принимает int в диапазоне 0 – 35
 */
/*
 rotate_vector = 0 – по часовой, 1 – против часовой стрелки

 */


- (IBAction)startButtonTap:(id)sender
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     {"response":"start",
     ”game_type”:0,
     ”card_type”:0,
     ”user_shuffle”:true,
     "rotate_count":0, 
     "rotate_vector":0 
     }
     }
     */
    
    [dict setObject:@"start" forKey:@"response"];
    
    [dict setObject:[NSNumber numberWithInteger:game_type] forKey:@"game_type"];
    [dict setObject:[NSNumber numberWithInteger:card_type] forKey:@"card_type"];
    [dict setObject:[NSNumber numberWithBool:_swich.isOn] forKey:@"user_shuffle"];
    [dict setObject:[NSNumber numberWithInteger:rotate_count] forKey:@"rotate_count"];
    [dict setObject:[NSNumber numberWithInteger:rotate_vector] forKey:@"rotate_vector"];
    
    [myAPI sendMessage:[myAPI objectToJSONString:dict]];
    
}
- (IBAction)button_1_tap:(id)sender
{
    /*
     game_type = 0 – классическая
     game_type = 1 – дистанция
     game_type = 2 – гараж (если выбран то обязательный параметр parking_count принимает int в диапазоне 0 – 15)
     */
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Выберите тип игры:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* clasik = [UIAlertAction actionWithTitle:@"Классическая" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        game_type = 0;
        [_button_1 setTitle:@"Классическая" forState:UIControlStateNormal];
    }];
    UIAlertAction* dist = [UIAlertAction actionWithTitle:@"Дистанция" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        game_type = 1;
        [_button_1 setTitle:@"Дистанция" forState:UIControlStateNormal];
    }];
    UIAlertAction* garag = [UIAlertAction actionWithTitle:@"Гараж" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        game_type = 2;
        [self hideShowButton];
        [_button_1 setTitle:@"Гараж" forState:UIControlStateNormal];
        [_button_2 setTitle:@"0" forState:UIControlStateNormal];
    }];
    [alertControl addAction:clasik];
    [alertControl addAction:dist];
    [alertControl addAction:garag];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (IBAction)button_2_tap:(id)sender
{
    //parking_count принимает int в диапазоне 0 – 15
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Выберите количество гаражей:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0 ; i<16; i++) {
        UIAlertAction* alert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%i",i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_button_2 setTitle:[NSString stringWithFormat:@"%i",i] forState:UIControlStateNormal];
            parking_count = i;
        }];
        
        [alertControl addAction:alert];
    }
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (IBAction)button_3_tap:(id)sender
{
    /*
     card_type = 0 – вся колода
     card_type = 1 – 3 карты
     */
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Как роздать карты:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* clasik = [UIAlertAction actionWithTitle:@"вся колода" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_button_3 setTitle:@"вся колода" forState:UIControlStateNormal];
        card_type = 0;
    }];
    UIAlertAction* dist = [UIAlertAction actionWithTitle:@"3 карты" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_button_3 setTitle:@"3 карты" forState:UIControlStateNormal];
        card_type = 1;
    }];

    [alertControl addAction:clasik];
    [alertControl addAction:dist];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (IBAction)button_4_tap:(id)sender
{
    /*
     rotate_count = 0 – принимает int в диапазоне 0 – 35
     */
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Выберите количество карт которые будут вращаться:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0 ; i<36; i++) {
        UIAlertAction* alert = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%i",i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_button_4 setTitle:[NSString stringWithFormat:@"%i",i] forState:UIControlStateNormal];
            rotate_count = i;
        }];
        
        [alertControl addAction:alert];
    }
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (IBAction)button_5_tap:(id)sender
{
    /*
     rotate_vector = 0 – по часовой, 1 – против часовой стрелки
     
     */
    UIAlertController* alertControl = [UIAlertController alertControllerWithTitle:@"Как вращать карты:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* clasik = [UIAlertAction actionWithTitle:@"по часовой" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_button_5 setTitle:@"по часовой" forState:UIControlStateNormal];
        rotate_vector = 0;
    }];
    UIAlertAction* dist = [UIAlertAction actionWithTitle:@"против часовой стрелки" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_button_5 setTitle:@"против часовой стрелки" forState:UIControlStateNormal];
        rotate_vector = 1;
    }];
    
    [alertControl addAction:clasik];
    [alertControl addAction:dist];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}
@end

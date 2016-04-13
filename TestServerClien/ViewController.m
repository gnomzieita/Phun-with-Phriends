//
//  ViewController.m
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "ViewController.h"
#import "GameCardView.h"


@interface ViewController ()

@property (strong, nonatomic) API* myAPI;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _myAPI = [API sharedController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

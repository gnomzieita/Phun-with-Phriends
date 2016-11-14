//
//  SingleViewController.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 11.10.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "SingleViewController.h"
#import "GameCardView.h"

@interface SingleViewController ()
{
    NSInteger startR;
    NSInteger startX,startY;
    
    NSArray* arrayOfCard;
}

@property (assign, nonatomic) NSInteger rotate;

@property (strong, nonatomic) IBOutletCollection(GameCardView) NSArray *kubiki;
@property (strong, nonatomic) NSMutableArray *map;

@property (strong, nonatomic) NSMutableArray *cardArray;

- (IBAction)cartTap:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *kubPole;

@property (weak, nonatomic) IBOutlet GameCardView *card_1;
@property (weak, nonatomic) IBOutlet GameCardView *card_2;
@property (weak, nonatomic) IBOutlet GameCardView *card_3;
@property (strong, nonatomic) IBOutlet GameCardView *selectCard;


- (IBAction)card_1_tap:(id)sender;
- (IBAction)card_2_tap:(id)sender;
- (IBAction)card_3_tap:(id)sender;


- (IBAction)left_tap:(id)sender;
- (IBAction)right_tap:(id)sender;

@end

@implementation SingleViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    
    arrayOfCard = [NSArray arrayWithObjects:_card_1,_card_2,_card_3, nil];
    // Do any additional setup after loading the view.
    _map = [NSMutableArray array];
    for (int y = 0; y<6; y++) {
        NSMutableArray* temprray = [NSMutableArray array];
        for (int x = 0; x<6; x++) {
            GameCardView* view = [_kubiki objectAtIndex:y*6+x];
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [UIColor blackColor].CGColor;
            [view setBackgroundColor:[UIColor whiteColor]];
            [view setType:GameCardType_0 startRoad:0 rotate:NO];
            [temprray addObject:view];
        }
        [_map addObject:temprray];
    }
    startX = arc4random()%6;
    if (startX == 0 || startX == 5) {
        startY = arc4random()%6;
    }
    else
    {
        startY = arc4random()%2*5;
    }
    
    NSMutableArray* tempStartArray = [NSMutableArray array];
    if (startX == 0)
    {
        [tempStartArray addObject:@"7"];
        [tempStartArray addObject:@"8"];
    }
    if (startX == 5)
    {
        [tempStartArray addObject:@"3"];
        [tempStartArray addObject:@"4"];
    }
    
    if (startY == 0)
    {
        [tempStartArray addObject:@"1"];
        [tempStartArray addObject:@"2"];
    }
    if (startY == 5)
    {
        [tempStartArray addObject:@"5"];
        [tempStartArray addObject:@"6"];
    }
    
    startR = [[tempStartArray objectAtIndex:(arc4random()%(tempStartArray.count))] integerValue];
    //[self nextStepSetType:arc4random()%35+1];
    [self genNextCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger) getnextStart:(NSInteger)finish
{
    switch (finish) {
        case 1:
            return 6;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 8;
            break;
        case 4:
            return 7;
            break;
        case 5:
            return 2;
            break;
        case 6:
            return 1;
            break;
        case 7:
            return 4;
            break;
        case 8:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (void) nextStepSetType:(GameCardType)cardType
{
    GameCardView* tempView = [[_map objectAtIndex:startY] objectAtIndex:startX];
    if (tempView.pointArray) {
        
        GameCardView* view = [[GameCardView alloc] initWithFrame:tempView.frame];
        view.pointArray = tempView.pointArray;
        [view setType:cardType startRoad:startR rotate:_rotate];
        
        [tempView removeFromSuperview];
        
        [_kubPole addSubview:view];
        tempView = view;
    }
    else
    {
         [tempView setType:cardType startRoad:startR rotate:_rotate];
    }
    NSInteger temp = [[[tempView.cardTable objectForKey:[NSNumber numberWithInteger:cardType]] objectAtIndex:((startR+_rotate*2)>8?(startR+_rotate*2)%8:(startR+_rotate*2))-1] integerValue];
    //temp = (startR+_rotate*2)>8?(startR+_rotate*2)%8:(startR+_rotate*2);
    BOOL flag = YES;
    switch ((temp-1)/2) {
        case 0:
        {
            if (startY-1>=0)
            {
                startY = startY-1;
                startR = [self getnextStart:temp];
              }
            else
            {
                NSLog(@"Вылетел зв предел поля");
                flag = NO;
            }
        }
            break;
        case 1:
        {
            if (startX+1<=5)
            {
                startX = startX+1;
                startR = [self getnextStart:temp];
            }
            else
            {
                NSLog(@"Вылетел зв предел поля");
                flag = NO;
            }
        }
            break;
        case 2:
        {
            if (startY+1<=5)
            {
                startY = startY+1;
                startR = [self getnextStart:temp];
            }
            else
            {
                NSLog(@"Вылетел зв предел поля");
                flag = NO;
            }
        }
            break;
        case 3:
        {
            if (startX-1>=0)
            {
                startX = startX-1;
                startR = [self getnextStart:temp];
            }
            else
            {
                NSLog(@"Вылетел зв предел поля");
                flag = NO;
            }
        }
            break;
            
        default:
        {
            NSLog(@"Чет не то))");
            flag = NO;
        }
            break;
    }
    if (flag) {
        GameCardView* tV = [[_map objectAtIndex:startY] objectAtIndex:startX];
        if (!tV.cardType) {
            [self genNextCard];
        }
        else
        {
            [self nextStepSetType:tV.cardType];
        }
    }
}

-(NSInteger) getRandomCard
{
    if (!_cardArray) {
        _cardArray = [NSMutableArray array];
        while (_cardArray.count<35) {
            NSNumber* tempNum = [NSNumber numberWithInteger:arc4random()%35+1];
            if (![_cardArray containsObject:tempNum]) {
                [_cardArray addObject:tempNum];
            }
        }
    }
    
    NSInteger index = arc4random()%_cardArray.count;
    NSInteger obj = [[_cardArray objectAtIndex:index] integerValue];
    [_cardArray removeObjectAtIndex:index];
    
    return obj;
}

- (IBAction)cartTap:(id)sender
{
    //[self nextStepSetType:arc4random()%35+1];_selectCard
    [self nextStepSetType:_selectCard.cardType];
}

- (void) setSelectedCard:(GameCardView *)selectCard
{
    for (GameCardView* tempCard in arrayOfCard) {
        if (tempCard == selectCard) {
            tempCard.layer.borderColor = [UIColor blueColor].CGColor;
            tempCard.layer.borderWidth = 4.5f;
            
        }
        else
        {
            tempCard.layer.borderColor = [UIColor blackColor].CGColor;
            tempCard.layer.borderWidth = 1;
        }
    }
}

- (void) setSelectedKub:(GameCardView *)selectKub
{
    for (GameCardView* tempCard in _kubiki) {
        if (tempCard == selectKub) {
            tempCard.layer.borderColor = [UIColor blueColor].CGColor;
            tempCard.layer.borderWidth = 4.5f;
            
        }
        else
        {
            tempCard.layer.borderColor = [UIColor blackColor].CGColor;
            tempCard.layer.borderWidth = 1;
        }
    }
}
- (IBAction)card_1_tap:(id)sender
{
    _rotate = 0;
    GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
    [view setType:_card_1.cardType startRoad:_card_1.startRoad rotate:_rotate];
    view.isRotatingCard = _card_1.isRotatingCard;
    view.roadColor = _card_1.roadColor;
    
    [_selectCard removeFromSuperview];
    
    [self.view addSubview:view];
    _selectCard = view;
    [self setSelectedCard:_card_1];
}

- (IBAction)card_2_tap:(id)sender
{
    _rotate = 0;
    GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
    [view setType:_card_2.cardType startRoad:_card_2.startRoad rotate:_rotate];
    view.isRotatingCard = _card_2.isRotatingCard;
    view.roadColor = _card_2.roadColor;
    [_selectCard removeFromSuperview];
    
    [self.view addSubview:view];
    _selectCard = view;
    [self setSelectedCard:_card_2];
}

- (IBAction)card_3_tap:(id)sender
{
    _rotate = 0;
    GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
    [view setType:_card_3.cardType startRoad:_card_3.startRoad rotate:_rotate];
    view.isRotatingCard = _card_3.isRotatingCard;
    view.roadColor = _card_3.roadColor;
    
    [_selectCard removeFromSuperview];
    
    [self.view addSubview:view];
    _selectCard = view;
    [self setSelectedCard:_card_3];
}

- (IBAction)left_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(-M_PI_2);
        _rotate = _rotate-1<0?3:_rotate-1;
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_rotate];
        view.isRotatingCard = _selectCard.isRotatingCard;
        view.roadColor = _selectCard.roadColor;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}

- (IBAction)right_tap:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        _selectCard.transform = CGAffineTransformMakeRotation(M_PI_2);
        _rotate = _rotate+1>3?0:_rotate+1;
        
    } completion:^(BOOL finished) {
        GameCardView* view = [[GameCardView alloc] initWithFrame:_selectCard.frame];
        [view setType:_selectCard.cardType startRoad:_selectCard.startRoad rotate:_rotate];
        view.isRotatingCard = _selectCard.isRotatingCard;
        view.roadColor = _selectCard.roadColor;
        [_selectCard removeFromSuperview];
        
        [self.view addSubview:view];
        _selectCard = view;
    }];
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (void) genNextCard
{
    _card_1.pointArray = nil;
    _card_2.pointArray = nil;
    _card_3.pointArray = nil;
    _selectCard.pointArray = nil;
    
    [_card_1 setType:[self getRandomCard] startRoad:startR rotate:_rotate];
    [_card_2 setType:[self getRandomCard] startRoad:startR rotate:_rotate];
    [_card_3 setType:[self getRandomCard] startRoad:startR rotate:_rotate];
    [_selectCard setType:_card_1.cardType startRoad:startR rotate:_rotate];
    
    [self setSelectedCard:_card_1];
    [self setSelectedKub:(GameCardView *)[[_map objectAtIndex:startY] objectAtIndex:startX]];
}
@end

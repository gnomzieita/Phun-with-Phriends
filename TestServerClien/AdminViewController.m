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
#import "AdminCollectionViewCell.h"

#import "AdminCollectionViewCell.h"
#import "Admin2CollectionViewCell.h"
#import "AdminCell3CollectionViewCell.h"
#import "SettingsProtocol.h"


@interface AdminViewController ()<UICollectionViewDataSource, SettingsProtocol>
{
    NSInteger game_type;
    NSInteger parking_count;
    NSInteger card_type;
    NSInteger rotate_count;
    NSInteger rotate_vector;
    NSInteger user_shuffle;
    PWPPlayer* player;
    API* myAPI;
}
@property (weak, nonatomic) IBOutlet UICollectionView *table;

- (IBAction)startButtonTap:(id)sender;

- (IBAction)backTap:(id)sender;

- (IBAction)leftButtonTap:(id)sender;
- (IBAction)rightButtonTap:(id)sender;


@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAPI = [API sharedController];
    //[self hideShowButton];

    
    
    game_type = 0;
    //[_button_1 setTitle:NSLocalizedString(@"game_type_klasik",@"Классическая") forState:UIControlStateNormal];

    //[_button_3 setTitle:NSLocalizedString(@"game_type_koloda",@"вся колода") forState:UIControlStateNormal];
    card_type = 0;
    //[_button_4 setTitle:@"0" forState:UIControlStateNormal];
    rotate_count = 0;
    //[_button_5 setTitle:NSLocalizedString(@"po_chasovoi",@"по часовой") forState:UIControlStateNormal];
    rotate_vector = 0;
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameInitNotification)
                                                 name:@"gameStart"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settings_sync:)
                                                 name:@"settings_sync"
                                               object:nil];
   // [self startButtonTap:nil];
   // _startButton.layer.cornerRadius = 10.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) settings_sync:(NSNotification *) notification
{
    NSDictionary* syncDict = [NSDictionary dictionaryWithDictionary:[notification userInfo]];
    game_type = [[syncDict objectForKey:@"game_type"] integerValue];
    card_type = [[syncDict objectForKey:@"card_type"] integerValue];
    rotate_count = [[syncDict objectForKey:@"rotate_count"] integerValue];
    rotate_vector = [[syncDict objectForKey:@"rotate_vector"] integerValue];
    user_shuffle = [[syncDict objectForKey:@"user_shuffle"] boolValue];
    parking_count = [[syncDict objectForKey:@"parking_count"] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"settings_sync_cell" object:self userInfo:syncDict];
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

- (IBAction)startButtonTap:(id)sender
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     {"command":"start",
     ”game_type”:0,
     ”card_type”:0,
     ”user_shuffle”:true,
     "rotate_count":0, 
     "rotate_vector":0 
     }
     }
     */
    
    [dict setObject:@"start" forKey:@"command"];
    
    [dict setObject:[NSNumber numberWithInteger:game_type] forKey:@"game_type"];
    [dict setObject:[NSNumber numberWithInteger:card_type] forKey:@"card_type"];
    [dict setObject:[NSNumber numberWithBool:user_shuffle] forKey:@"user_shuffle"];
    [dict setObject:[NSNumber numberWithInteger:rotate_count] forKey:@"rotate_count"];
    [dict setObject:[NSNumber numberWithInteger:rotate_vector] forKey:@"rotate_vector"];
    [dict setObject:[NSNumber numberWithInteger:parking_count] forKey:@"parking_count"];
    [myAPI sendMessage:[myAPI objectToJSONString:dict] ];
}

- (IBAction)backTap:(id)sender
{
    [myAPI closeConnect];
    [myAPI popToTop:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            AdminCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdminCollectionViewCell" forIndexPath:indexPath];
            
            [cell initCell];
            [cell setDelegat:self];
            return  cell;
        }
            break;
        case 1:
        {
            Admin2CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Admin2CollectionViewCell" forIndexPath:indexPath];
            
            
            [cell initCell];
            [cell setDelegat:self];
            return  cell;
        }
            break;
        case 2:
        {
            AdminCell3CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdminCell3CollectionViewCell" forIndexPath:indexPath];
            
            [cell initCell];
            [cell setDelegat:self];
            return  cell;
        }
            break;
            
        case 3:
        {
            AdminCell3CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AdminCell4CollectionViewCell" forIndexPath:indexPath];
            
            [cell initCell];
            [cell setDelegat:self];
            return  cell;
        }
            break;
            
        default:
            break;
    }
    
    
    return  nil;
}

- (void) setGame_type:(NSInteger)type
{
    game_type = type;
    [self settings_sync];
}
- (void) setParking_count:(NSInteger)count
{
    parking_count = count;
    [self settings_sync];
}
- (void) setCard_type:(NSInteger)type
{
    card_type = type;
    [self settings_sync];
}
- (void) setRotate_count:(NSInteger)count
{
    rotate_count = count;
    [self settings_sync];
}
- (void) setRotate_vector:(NSInteger)vector
{
    rotate_vector = vector;
    [self settings_sync];
}

- (NSInteger) getGame_type
{
    return game_type;
}
- (NSInteger) getParking_count
{
    return parking_count;
}
- (NSInteger) getCard_type
{
    return card_type;
}
- (NSInteger) getRotate_count
{
    return rotate_count;
}
- (NSInteger) getRotate_vector
{
    return rotate_vector;
}

- (void) setUser_shuffle:(BOOL)shuffle
{
    user_shuffle = shuffle;
    [self settings_sync];
}

- (BOOL) getUser_shuffle
{
    return user_shuffle;
}

- (void) settings_sync
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    /*
     {
     {"command":"start",
     ”game_type”:0,
     ”card_type”:0,
     ”user_shuffle”:true,
     "rotate_count":0,
     "rotate_vector":0
     }
     }
     */
    
    [dict setObject:@"settings_sync" forKey:@"command"];
    
    [dict setObject:[NSNumber numberWithInteger:game_type] forKey:@"game_type"];
    [dict setObject:[NSNumber numberWithInteger:card_type] forKey:@"card_type"];
    [dict setObject:[NSNumber numberWithBool:user_shuffle] forKey:@"user_shuffle"];
    [dict setObject:[NSNumber numberWithInteger:rotate_count] forKey:@"rotate_count"];
    [dict setObject:[NSNumber numberWithInteger:rotate_vector] forKey:@"rotate_vector"];
    
    [myAPI sendMessage:[myAPI objectToJSONString:dict] ];
}

/*
 
 */
- (IBAction)leftButtonTap:(id)sender
{
    NSArray* tempArray = [NSArray arrayWithArray:[_table indexPathsForVisibleItems]];
    NSIndexPath* tempPach = [tempArray lastObject];
    switch (tempPach.item) {
        case 0:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 1:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 2:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 3:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)rightButtonTap:(id)sender
{
    NSArray* tempArray = [NSArray arrayWithArray:[_table indexPathsForVisibleItems]];
    NSIndexPath* tempPach = [tempArray lastObject];
    switch (tempPach.item) {
        case 0:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 1:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 2:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
        case 3:
        {
            [_table scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                           atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end

//
//  GameCardView.h
//  TestServerClien
//
//  Created by Alex Agarkov on 31.03.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameCardType) {
    GameCardType_1 = 1,
    GameCardType_2,
    GameCardType_3,
    GameCardType_4,
    GameCardType_5,
    GameCardType_6,
    GameCardType_7,
    GameCardType_8,
    GameCardType_9,
    GameCardType_10,
    GameCardType_11,
    GameCardType_12,
    GameCardType_13,
    GameCardType_14,
    GameCardType_15,
    GameCardType_16,
    GameCardType_17,
    GameCardType_18,
    GameCardType_19,
    GameCardType_20,
    GameCardType_21,
    GameCardType_22,
    GameCardType_23,
    GameCardType_24,
    GameCardType_25,
    GameCardType_26,
    GameCardType_27,
    GameCardType_28,
    GameCardType_29,
    GameCardType_30,
    GameCardType_31,
    GameCardType_32,
    GameCardType_33,
    GameCardType_34,
    GameCardType_35
};

@interface GameCardView : UIView

@property (assign, nonatomic) BOOL isRotatingCard;
@property (assign, nonatomic) GameCardType cardType;
@property (assign, nonatomic) NSInteger rotate;
@property (assign, nonatomic) NSInteger startRoad;
@property (assign, nonatomic) UIColor* roadColor;

- (instancetype)initInPoint:(CGPoint)point WithHeight:(CGFloat)kubHeight WithType:(GameCardType)cType;
- (void)setType:(GameCardType)cType startRoad:(NSInteger)startRoad rotate:(NSInteger)rotate;

@end

//
//  GameCardView.m
//  TestServerClien
//
//  Created by Alex Agarkov on 31.03.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "GameCardView.h"
@interface GameCardView ()

@property (assign, nonatomic) CGFloat kubHeight;
@property (assign, nonatomic) CGFloat kubStep;

@property (strong, nonatomic) NSDictionary* cardTable;

@end

@implementation GameCardView

- (instancetype)initInPoint:(CGPoint)point WithHeight:(CGFloat)kubHeight WithType:(GameCardType)cType
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, kubHeight, kubHeight)];
    _kubHeight = kubHeight;
    _kubStep = kubHeight/3;
    _cardType = cType;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    [self setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}

- (void)setType:(GameCardType)cType startRoad:(NSInteger)startRoad rotate:(NSInteger)rotate
{
    [self setNeedsDisplay];
    _rotate = rotate;
    _startRoad = startRoad;
    
    _cardTable = @{[NSNumber numberWithInteger:1]:@[@"2",@"1",@"4",@"3",@"6",@"5",@"8",@"7"],
                   [NSNumber numberWithInteger:2]:@[@"2",@"1",@"4",@"3",@"7",@"8",@"5",@"6"],
                   [NSNumber numberWithInteger:3]:@[@"3",@"7",@"1",@"6",@"8",@"4",@"2",@"5"],
                   [NSNumber numberWithInteger:4]:@[@"4",@"3",@"2",@"1",@"6",@"5",@"8",@"7"],
                   [NSNumber numberWithInteger:5]:@[@"4",@"3",@"2",@"1",@"8",@"7",@"6",@"5"],
                   [NSNumber numberWithInteger:6]:@[@"4",@"7",@"6",@"1",@"8",@"3",@"2",@"5"],
                   [NSNumber numberWithInteger:7]:@[@"5",@"4",@"6",@"2",@"1",@"3",@"8",@"7"],
                   [NSNumber numberWithInteger:8]:@[@"6",@"7",@"8",@"5",@"4",@"1",@"2",@"3"],
                   [NSNumber numberWithInteger:9]:@[@"6",@"8",@"4",@"3",@"7",@"1",@"5",@"2"],
                   [NSNumber numberWithInteger:10]:@[@"6",@"8",@"5",@"7",@"3",@"1",@"4",@"2"],
                   [NSNumber numberWithInteger:11]:@[@"7",@"3",@"2",@"6",@"8",@"4",@"1",@"5"],
                   [NSNumber numberWithInteger:12]:@[@"7",@"4",@"5",@"2",@"3",@"8",@"1",@"6"],
                   [NSNumber numberWithInteger:13]:@[@"7",@"5",@"6",@"8",@"2",@"3",@"1",@"4"],
                   [NSNumber numberWithInteger:14]:@[@"8",@"3",@"2",@"5",@"4",@"7",@"6",@"1"],
                   [NSNumber numberWithInteger:15]:@[@"8",@"4",@"5",@"2",@"3",@"7",@"6",@"1"],
                   [NSNumber numberWithInteger:16]:@[@"8",@"4",@"7",@"2",@"6",@"5",@"3",@"1"],
                   [NSNumber numberWithInteger:17]:@[@"8",@"5",@"4",@"3",@"2",@"7",@"6",@"1"],
                   [NSNumber numberWithInteger:18]:@[@"6",@"5",@"7",@"8",@"2",@"1",@"3",@"4"],
                   [NSNumber numberWithInteger:19]:@[@"3",@"8",@"1",@"7",@"6",@"5",@"4",@"2"],
                   [NSNumber numberWithInteger:20]:@[@"4",@"6",@"5",@"1",@"3",@"2",@"8",@"7"],
                   [NSNumber numberWithInteger:21]:@[@"6",@"5",@"4",@"3",@"2",@"1",@"8",@"7"],
                   [NSNumber numberWithInteger:22]:@[@"7",@"8",@"5",@"6",@"3",@"4",@"1",@"2"],
                   [NSNumber numberWithInteger:23]:@[@"6",@"5",@"8",@"7",@"2",@"1",@"4",@"3"],
                   [NSNumber numberWithInteger:24]:@[@"5",@"7",@"6",@"8",@"1",@"3",@"2",@"4"],
                   [NSNumber numberWithInteger:25]:@[@"6",@"4",@"7",@"2",@"8",@"1",@"3",@"5"],
                   [NSNumber numberWithInteger:26]:@[@"3",@"6",@"1",@"8",@"7",@"2",@"5",@"4"],
                   [NSNumber numberWithInteger:27]:@[@"5",@"8",@"7",@"6",@"1",@"4",@"3",@"2"],
                   [NSNumber numberWithInteger:28]:@[@"7",@"3",@"2",@"8",@"6",@"5",@"1",@"4"],
                   [NSNumber numberWithInteger:29]:@[@"7",@"8",@"6",@"5",@"4",@"3",@"1",@"2"],
                   [NSNumber numberWithInteger:30]:@[@"6",@"7",@"4",@"3",@"8",@"1",@"2",@"5"],
                   [NSNumber numberWithInteger:31]:@[@"5",@"6",@"7",@"8",@"1",@"2",@"3",@"4"],
                   [NSNumber numberWithInteger:32]:@[@"8",@"5",@"7",@"6",@"2",@"4",@"3",@"1"],
                   [NSNumber numberWithInteger:33]:@[@"8",@"6",@"5",@"7",@"3",@"2",@"4",@"1"],
                   [NSNumber numberWithInteger:34]:@[@"5",@"6",@"4",@"3",@"1",@"2",@"8",@"7"],
                   [NSNumber numberWithInteger:35]:@[@"5",@"3",@"2",@"8",@"1",@"7",@"6",@"4"]};
    
    _cardType = cType;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    [self setBackgroundColor:[UIColor whiteColor]];
    if (_isRotatingCard) {
        self.layer.cornerRadius = self.frame.size.width/4;
        //[self setBackgroundColor:[UIColor yellowColor]];
    }
    [self drawRect:self.frame];

}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_cardTable) {
        _kubHeight = rect.size.height;
        _kubStep = _kubHeight/3;
        
        //NSMutableArray* tempDict = [NSMutableArray array];
        NSArray* numArray = [_cardTable objectForKey:[NSNumber numberWithInteger:_cardType]];
        
        //[tempDict addObject:@"1"];
        
        for (int i = 1; i<9; i++) {
            NSInteger moveIn = (i+_rotate*2)>8?(i+_rotate*2)%8:(i+_rotate*2);
            NSInteger moveTo = ([[numArray objectAtIndex:i-1] integerValue]+_rotate*2)>8?([[numArray objectAtIndex:i-1] integerValue]+_rotate*2)%8: ([[numArray objectAtIndex:i-1] integerValue]+_rotate*2);
            NSLog(@"%i -> %i",moveIn,moveTo);
            [self moveIn:moveIn toPoint:moveTo];
//            if (![tempDict containsObject:[NSString stringWithFormat:@"%i",moveIn]] && ![tempDict containsObject:[NSString stringWithFormat:@"%i",moveTo]]) {
//                [tempDict addObject:[NSString stringWithFormat:@"%i",moveIn]];
//                [tempDict addObject:[NSString stringWithFormat:@"%i",moveTo]];
//                [self moveIn:moveIn toPoint:moveTo];
//                
//                
//            }
        }
    }
    
}


#pragma mark - Все состояния 1
- (void) draw_1_to_2:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, nil, _kubStep*1, _kubStep*0);
    CGPathAddCurveToPoint(*path, nil, _kubStep*1, _kubStep*1,_kubStep*2, _kubStep*1, _kubStep*2, _kubStep*0);
    //CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1.5f, _kubStep*1, _kubStep*2, _kubStep*0);
}

- (void) draw_1_to_3:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*1, _kubStep*3, _kubStep*1);
}

- (void) draw_1_to_4:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*2, _kubStep*3, _kubStep*2);
}

- (void) draw_1_to_5:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddCurveToPoint(*path, nil, _kubStep*1, _kubStep*2,_kubStep*2, _kubStep*1, _kubStep*2, _kubStep*3);
}

- (void) draw_1_to_6:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddLineToPoint(*path, nil, _kubStep*1, _kubStep*3);
}

- (void) draw_1_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*2, _kubStep*0, _kubStep*2);
}

- (void) draw_1_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 2
- (void) draw_2_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_2:path];
}

- (void) draw_2_to_3:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*1, _kubStep*3, _kubStep*1);
}

- (void) draw_2_to_4:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*2, _kubStep*3, _kubStep*2);
}

- (void) draw_2_to_5:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddLineToPoint(*path, nil, _kubStep*2, _kubStep*3);
}

- (void) draw_2_to_6:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddCurveToPoint(*path, nil, _kubStep*2, _kubStep*2,_kubStep*1, _kubStep*1, _kubStep*1, _kubStep*3);
}

- (void) draw_2_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*2, _kubStep*0, _kubStep*2);
}

- (void) draw_2_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*0);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 3
- (void) draw_3_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_3:path];
}

- (void) draw_3_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_3:path];
}

- (void) draw_3_to_4:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*1);
    CGPathAddCurveToPoint(*path, nil, _kubStep*2, _kubStep*1,_kubStep*2, _kubStep*2, _kubStep*3, _kubStep*2);
}

- (void) draw_3_to_5:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*1);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*1, _kubStep*2, _kubStep*3);
}

- (void) draw_3_to_6:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*1);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*1, _kubStep*1, _kubStep*3);
}

- (void) draw_3_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*1);
    CGPathAddCurveToPoint(*path, nil, _kubStep*1, _kubStep*1,_kubStep*2, _kubStep*2, _kubStep*0, _kubStep*2);
}

- (void) draw_3_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*1);
    CGPathAddLineToPoint(*path, nil, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 4
- (void) draw_4_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_4:path];
}

- (void) draw_4_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_4:path];
}

- (void) draw_4_to_3:(CGMutablePathRef*)path
{
    [self draw_3_to_4:path];
}

- (void) draw_4_to_5:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*2);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*2, _kubStep*2, _kubStep*3);
}

- (void) draw_4_to_6:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*2);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*2, _kubStep*1, _kubStep*3);
}

- (void) draw_4_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*2);
    CGPathAddLineToPoint(*path, nil, _kubStep*0, _kubStep*2);
}

- (void) draw_4_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*3, _kubStep*2);
    CGPathAddCurveToPoint(*path, nil, _kubStep*1, _kubStep*2,_kubStep*2, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 5
- (void) draw_5_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_5:path];
}

- (void) draw_5_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_5:path];
}

- (void) draw_5_to_3:(CGMutablePathRef*)path
{
    [self draw_3_to_5:path];
}

- (void) draw_5_to_4:(CGMutablePathRef*)path
{
    [self draw_4_to_5:path];
}

- (void) draw_5_to_6:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*3);
    CGPathAddCurveToPoint(*path, nil, _kubStep*2, _kubStep*2,_kubStep*1, _kubStep*2, _kubStep*1, _kubStep*3);
}

- (void) draw_5_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*3);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*2, _kubStep*0, _kubStep*2);
}

- (void) draw_5_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*2, _kubStep*3);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*2, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 6
- (void) draw_6_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_6:path];
}

- (void) draw_6_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_6:path];
}

- (void) draw_6_to_3:(CGMutablePathRef*)path
{
    [self draw_3_to_6:path];
}

- (void) draw_6_to_4:(CGMutablePathRef*)path
{
    [self draw_4_to_6:path];
}

- (void) draw_6_to_5:(CGMutablePathRef*)path
{
    [self draw_5_to_6:path];
}

- (void) draw_6_to_7:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*3);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*2, _kubStep*0, _kubStep*2);
}

- (void) draw_6_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*1, _kubStep*3);
    CGPathAddQuadCurveToPoint(*path, nil, _kubStep*1, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 7
- (void) draw_7_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_7:path];
}

- (void) draw_7_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_7:path];
}

- (void) draw_7_to_3:(CGMutablePathRef*)path
{
    [self draw_3_to_7:path];
}

- (void) draw_7_to_4:(CGMutablePathRef*)path
{
    [self draw_4_to_7:path];
}

- (void) draw_7_to_5:(CGMutablePathRef*)path
{
    [self draw_5_to_7:path];
}

- (void) draw_7_to_6:(CGMutablePathRef*)path
{
    [self draw_6_to_7:path];
}

- (void) draw_7_to_8:(CGMutablePathRef*)path
{
    CGPathMoveToPoint(*path, NULL, _kubStep*0, _kubStep*2);
    CGPathAddCurveToPoint(*path, nil, _kubStep*1, _kubStep*2,_kubStep*1, _kubStep*1, _kubStep*0, _kubStep*1);
}

#pragma mark - Все состояния 8
- (void) draw_8_to_1:(CGMutablePathRef*)path
{
    [self draw_1_to_8:path];
}

- (void) draw_8_to_2:(CGMutablePathRef*)path
{
    [self draw_2_to_8:path];
}

- (void) draw_8_to_3:(CGMutablePathRef*)path
{
    [self draw_3_to_8:path];
}

- (void) draw_8_to_4:(CGMutablePathRef*)path
{
    [self draw_4_to_8:path];
}

- (void) draw_8_to_5:(CGMutablePathRef*)path
{
    [self draw_5_to_8:path];
}

- (void) draw_8_to_6:(CGMutablePathRef*)path
{
    [self draw_6_to_8:path];
}

- (void) draw_8_to_7:(CGMutablePathRef*)path
{
    [self draw_7_to_8:path];
}

- (void) moveIn:(NSInteger)inPoint toPoint:(NSInteger)toPoint
{
    NSLog(@"moveIn:%li toPoint%li",(long)inPoint,(long)toPoint);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextClearRect(context,self.frame);
    CGMutablePathRef path = CGPathCreateMutable();
    
    const CGFloat color[] = { 0, 0, 1, 1 }; // Alpha should be 1, not 0!
    CGContextSetStrokeColor (context, color);
    
    switch (inPoint) {
        case 1:
        {
            switch (toPoint) {
                case 2:
                {
                    [self draw_1_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_1_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_1_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_1_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_1_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_1_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_1_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_2_to_1:&path];
                }
                    break;
                case 3:
                {
                    [self draw_2_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_2_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_2_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_2_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_2_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_2_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_3_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_3_to_2:&path];
                }
                    break;
                case 4:
                {
                    [self draw_3_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_3_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_3_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_3_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_3_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_4_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_4_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_4_to_3:&path];
                }
                    break;
                case 5:
                {
                    [self draw_4_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_4_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_4_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_4_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_5_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_5_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_5_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_5_to_4:&path];
                }
                    break;
                case 6:
                {
                    [self draw_5_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_5_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_5_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 6:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_6_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_6_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_6_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_6_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_6_to_5:&path];
                }
                    break;
                case 7:
                {
                    [self draw_6_to_7:&path];
                }
                    break;
                case 8:
                {
                    [self draw_6_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_7_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_7_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_7_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_7_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_7_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_7_to_6:&path];
                }
                    break;
                case 8:
                {
                    [self draw_7_to_8:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 8:
        {
            switch (toPoint) {
                case 1:
                {
                    [self draw_8_to_1:&path];
                }
                    break;
                case 2:
                {
                    [self draw_8_to_2:&path];
                }
                    break;
                case 3:
                {
                    [self draw_8_to_3:&path];
                }
                    break;
                case 4:
                {
                    [self draw_8_to_4:&path];
                }
                    break;
                case 5:
                {
                    [self draw_8_to_5:&path];
                }
                    break;
                case 6:
                {
                    [self draw_8_to_6:&path];
                }
                    break;
                case 7:
                {
                    [self draw_8_to_7:&path];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (inPoint == _startRoad || toPoint == _startRoad) {
        
        if (_roadColor) {
            CGContextSetFillColorWithColor(context, _roadColor.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        }
        NSLog(@"redColor");
        float x = 0;
        float y = 0;
        switch (_startRoad) {
            case 1:
            {
                x=1;
            }
                break;
            case 2:
            {
                x=2;
            }
                break;
            case 3:
            {
                x=3;
                y=1;
            }
                break;
            case 4:
            {
                x=3;
                y=2;
            }
                break;
            case 5:
            {
                x=2;
                y=3;
            }
                break;
            case 6:
            {
                x=1;
                y=3;
            }
                break;
            case 7:
            {
                y=2;
            }
                break;
            case 8:
            {
                y=1;
            }
                break;
                
            default:
                break;
        }
        CGPathMoveToPoint(path, NULL, _kubStep*x, _kubStep*y);
        CGPathAddArc(path, NULL, _kubStep*x, _kubStep*y, 5.f, -M_PI_2, M_PI_2*3, NO);

    }
    else
    {
//        if (_isRotatingCard) {
//            CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//        }
//        else
//        {
//            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//        }
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    if (_isRotatingCard) {
        CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    }
    CGPathRef thickPath = CGPathCreateCopyByStrokingPath(path, NULL, 4, kCGLineCapButt, kCGLineJoinBevel, 0);
    CGContextAddPath(context, thickPath);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextSetLineWidth(context, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(thickPath);
    CGPathRelease(path);

    
}
@end

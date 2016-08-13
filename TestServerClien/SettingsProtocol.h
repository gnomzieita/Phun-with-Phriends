//
//  SettingsProtocol.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 01.08.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

@protocol SettingsProtocol <NSObject>

@optional
- (void) setGame_type:(NSInteger)type;
- (void) setParking_count:(NSInteger)count;
- (void) setCard_type:(NSInteger)type;
- (void) setRotate_count:(NSInteger)count;
- (void) setRotate_vector:(NSInteger)vector;
- (void) setUser_shuffle:(BOOL)shuffle;

- (NSInteger) getGame_type;
- (NSInteger) getParking_count;
- (NSInteger) getCard_type;
- (NSInteger) getRotate_count;
- (NSInteger) getRotate_vector;
- (BOOL) getUser_shuffle;
@end

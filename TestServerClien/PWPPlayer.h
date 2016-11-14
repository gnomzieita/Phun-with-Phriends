//
//  PWPPlayer.h
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 23.09.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_OPTIONS(NSInteger, API_Sound) {
    API_Sound_Cheer,
    API_Sound_CountDown,
    API_Sound_Crash,
    API_Sound_DoorSlam,
    API_Sound_GameStart,
    API_Sound_HurryUp,
    API_Sound_idle,
    API_Sound_Music_Country,
    API_Sound_Music_Electro,
    API_Sound_Music_Intro,
    API_Sound_Music_Rock,
    API_Sound_Music_Upbeat,
    API_Sound_Rev
};

@interface PWPPlayer : NSObject <AVAudioPlayerDelegate>

{
    API_Sound playNow;
}
-(void)playSound:(API_Sound)soundType;
- (void) stopPlay;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

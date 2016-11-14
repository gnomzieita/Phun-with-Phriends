//
//  PWPPlayer.m
//  Phunky Phreeways
//
//  Created by Alex Agarkov on 23.09.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "PWPPlayer.h"

@implementation PWPPlayer

#pragma  mark - Sound


-(void)playSound:(API_Sound)soundType
{
    NSString *beepFilePath;
    playNow = soundType;
    switch (soundType) {
        case API_Sound_Rev:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Rev" ofType:@"mp3"];
            break;
        case API_Sound_idle:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"idle" ofType:@"mp3"];
            break;
        case API_Sound_Cheer:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Cheer" ofType:@"mp3"];
            break;
        case API_Sound_Crash:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Crsh" ofType:@"mp3"];
            break;
        case API_Sound_HurryUp:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Hurry Up" ofType:@"mp3"];
            break;
        case API_Sound_DoorSlam:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Door Slam" ofType:@"mp3"];
            break;
        case API_Sound_CountDown:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Count Down" ofType:@"mp3"];
            break;
        case API_Sound_GameStart:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Game Start" ofType:@"mp3"];
            break;
        case API_Sound_Music_Rock:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Music - Rock" ofType:@"mp3"];
            break;
        case API_Sound_Music_Intro:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"MusicIntro" ofType:@"mp3"];
            break;
        case API_Sound_Music_Upbeat:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Music - Upbeat" ofType:@"mp3"];
            break;
        case API_Sound_Music_Country:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Music - Country" ofType:@"mp3"];
            break;
        case API_Sound_Music_Electro:
            beepFilePath = [[NSBundle mainBundle] pathForResource:@"Music - Electro" ofType:@"mp3"];
            break;
            
        default:
            break;
    }
    
    NSURL *beepURL = [NSURL fileURLWithPath:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    [_audioPlayer setDelegate:self];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file:%ld",(long)soundType);
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        if ([_audioPlayer prepareToPlay]) {
            [_audioPlayer play];
        }
    }
}

#pragma  mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    switch (playNow) {
        case API_Sound_HurryUp:
            [player play];
            break;
        case API_Sound_idle:
            [player play];
            break;
            
        default:
            break;
    }
}

- (void) stopPlay
{
    [_audioPlayer stop];
    _audioPlayer = nil;
    playNow = 999;
}

@end

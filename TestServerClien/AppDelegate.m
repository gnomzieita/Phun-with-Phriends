//
//  AppDelegate.m
//  TestServerClien
//
//  Created by Alex Agarkov on 22.02.16.
//  Copyright © 2016 Alex Agarkov. All rights reserved.
//

#import "AppDelegate.h"
#import "API.h"
#import <Chartboost/Chartboost.h>
#import "ViewController.h"

@interface AppDelegate () <ChartboostDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //NSLog(@"IP: %@",[[API sharedController] getIPAddress]);
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
#if DEBUG
[Chartboost startWithAppId:@"4f21c409cd1cb2fb7000001b" appSignature:@"92e2de2fd7070327bdeb54c15a5295309c6fcd2d" delegate:self];//test
#else
[Chartboost startWithAppId:@"572edcddf6cd455523c31f87" appSignature:@"9d3c2186fb14781f0ef0873775c0b95b601bce4d" delegate:self];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/*
 * Chartboost Delegate Methods
 *
 */

/*
 * didInitialize
 *
 * This is used to signal when Chartboost SDK has completed its initialization.
 *
 * status is YES if the server accepted the appID and appSignature as valid
 * status is NO if the network is unavailable or the appID/appSignature are invalid
 *
 * Is fired on:
 * -after startWithAppId has completed background initialization and is ready to display ads
 */
- (void)didInitialize:(BOOL)status {
    NSLog(@"didInitialize");
    // chartboost is ready
//    [Chartboost cacheRewardedVideo:CBLocationMainMenu];
//    [Chartboost cacheMoreApps:CBLocationHomeScreen];
//    
//    // Show an interstitial whenever the app starts up
//    [Chartboost showInterstitial:CBLocationHomeScreen];
}


/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);
    
    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    NSLog(@"%@",[self getErrorText:error adType:@"Interstitial"]);
}

- (NSString *)getErrorText:(CBLoadError)e adType:(NSString *)t {
    NSString *errorText;
    switch(e){
        case CBLoadErrorInternal: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, internal error !",t];
        } break;
        case CBLoadErrorInternetUnavailable: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, no Internet connection !",t];
        } break;
        case CBLoadErrorTooManyConnections: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, too many connections !",t];
        } break;
        case CBLoadErrorWrongOrientation: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, wrong orientation !",t];
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, first session !",t];
        } break;
        case CBLoadErrorNetworkFailure: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, network error !",t];
        } break;
        case CBLoadErrorNoAdFound : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, no ad found !",t];
        } break;
        case CBLoadErrorSessionNotStarted : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, session not started !",t];
        } break;
        case CBLoadErrorImpressionAlreadyVisible : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, impression already visible !",t];
        } break;
        case CBLoadErrorUserCancellation : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, impression cancelled !",t];
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        case CBLoadErrorAssetDownloadFailure : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, asset download failed !",t];
        } break;
        case CBLoadErrorPrefetchingIncomplete : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, prefetching of video content is incomplete !",t];
        } break;
        default: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, unknown error %lul!", t, (long)e];
        }
    }
    return errorText;
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}

/*
 * didFailToLoadMoreApps
 *
 * This is called when the more apps page has failed to load for any reason
 *
 * Is fired on:
 * - No network connection
 * - No more apps page has been created (add a more apps page in the dashboard)
 * - No publishing campaign matches for that user (add more campaigns to your more apps page)
 *  -Find this inside the App > Edit page in the Chartboost dashboard
 */

- (void)didFailToLoadMoreApps:(NSString *)location withError:(CBLoadError)error {
    NSLog(@"%@",[self getErrorText:error adType:@"MoreApps"]);
}

/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
}

/*
 * didDismissMoreApps
 *
 * This is called when the more apps page is dismissed
 *
 * Is fired on:
 * - More Apps click
 * - More Apps close
 *
 */

- (void)didDismissMoreApps:(NSString *)location {
    NSLog(@"dismissed more apps page at location %@", location);
}

/*
 * didCompleteRewardedVideo
 *
 * This is called when a rewarded video has been viewed
 *
 * Is fired on:
 * - Rewarded video completed view
 *
 */
- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    NSLog(@"completed rewarded video view at location %@ with reward amount %d", location, reward);
}

/*
 * didFailToLoadRewardedVideo
 *
 * This is called when a Rewarded Video has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadRewardedVideo:(NSString *)location withError:(CBLoadError)error {
    NSLog(@"%@",[self getErrorText:error adType:@"Rewarded Video"]);
}

/*
 * didDisplayInterstitial
 *
 * Called after an interstitial has been displayed on the screen.
 */

- (void)didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Did display interstitial");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
    }
}


/*!
 @abstract
 Called after an InPlay object has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an InPlay object has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheInPlay:(CBLocation)location {
    NSLog(@"Successfully cached inPlay");
    //ViewController *vc = (ViewController*)self.window.rootViewController;
    //[vc renderInPlay:[Chartboost getInPlay:location]];
}

/*!
 @abstract
 Called after a InPlay has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an InPlay has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error {
    
    NSString *errorString = [self getErrorText:error adType:@"InPlay"];
    NSLog(@"Error: %@", errorString);
    
    //ViewController *vc = (ViewController*)self.window.rootViewController;
    //[vc renderInPlayError:errorString];
}
@end

//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/20/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Disable caching, so that we can demonstrate features related to making actual requests.
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

    MoviesViewController *movies = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"movieViewController"];

    movies.tabBarItem.title = @"Movies";
    movies.tabBarItem.image = [UIImage imageNamed:@"iconmonstr-video-5-icon-32.png"];
    movies.title = @"Movies";
    movies.endpoint = @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    UINavigationController *nmovies = [[UINavigationController alloc] initWithRootViewController:movies];

    MoviesViewController *dvd = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"movieViewController"];
    dvd.tabBarItem.title = @"DVD";
    UIImage *img = [UIImage imageNamed:@"iconmonstr-disc-2-icon-32.png"];
    dvd.tabBarItem.image = img;
    dvd.endpoint = @"https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json";

    dvd.title = @"DVD";
    UINavigationController *ndvd = [[UINavigationController alloc] initWithRootViewController:dvd];

    tabBarController.viewControllers = @[nmovies, ndvd];
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

@end

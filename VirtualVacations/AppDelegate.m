//
//  AppDelegate.m
//  VirtualVacations
//
//  Created by Norimasa Nabeta on 2012/08/09.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize imageCache = _imageCache;

// http://stackoverflow.com/questions/7598820/correct-singleton-pattern-objective-c-ios
// http://stackoverflow.com/questions/11691789/nscache-does-removeallobjects-release-the-memory-usage-im-using-arc
//
//
- (NSCache*) imageCache
{
    if(_imageCache == nil){
        _imageCache = [[NSCache alloc] init];
        [_imageCache setName:@"FlickrThumbnailImageCache"];
        [_imageCache setCountLimit:100];
        [_imageCache setTotalCostLimit:1500000];
        [_imageCache setEvictsObjectsWithDiscardedContent:YES];
    }
    return _imageCache;
}

/*
 NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
 NSData *data = [NSData dataWithContentsOfURL:url];

 
id appDelegate = (id)[[UIApplication sharedApplication] delegate];
 NSString *idThumbnail = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_ID];
UIImage *image = [[appDelegate imageCache] objectForKey:idThumbnail];
if (image) {
    // NSLog(@"HIT user:%@ screen:%@", tweetuser, tweetscreenuser);
    cell.imageView.image = image;
}
else {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [[appDelegate imageCache] setObject:[UIImage imageWithData:data] forKey:idThumbnail];
    dispatch_sync(dispatch_get_main_queue(), ^{
       [cell.imageView setImage:[UIImage imageWithData:data]];
       [self.tableView reloadData];
    });
  });
}
*/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

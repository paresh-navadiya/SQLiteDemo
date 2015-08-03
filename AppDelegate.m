//
//  AppDelegate.m
//  Practical
//
//  Created by ECWIT on 03/08/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize objSQLiteManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self copyDatabaseToDocumentDirectoryWithName:@"contact.db"];
    
    if (!self.objSQLiteManager) {
        self.objSQLiteManager = [[SQLiteManager alloc]initWithDatabaseNamed:@"contact.db"];
    }
    
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

#pragma mark -
#pragma mark - Copy DataBase Method
-(void)copyDatabaseToDocumentDirectoryWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle]pathForResource:[[name lastPathComponent]stringByDeletingPathExtension] ofType:[name pathExtension]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *documentsDirectory = [pathArray objectAtIndex:0];
        NSString *strFileDBPath = [documentsDirectory stringByAppendingPathComponent:name];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:strFileDBPath])//File exists in document directory
        {
            NSLog(@"Database exists");
        }
        else //File doesnot exists in document directory
        {
            //Need to copy file in document directory
            NSError *error = nil;
            if ([[NSFileManager defaultManager] copyItemAtPath:path toPath:strFileDBPath error:&error])
            { //copied successfully
                NSLog(@"Database copied");
            }
            else
            { //not copied
                NSLog(@"Database not copied");
            }
        }
    }
    else
    {
        NSLog(@"Database file does not exists");
    }
    
}

@end

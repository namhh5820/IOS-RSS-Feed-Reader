//
//  AppDelegate.h
//  15NHP-Feed
//
//  Created by admin on 13/05/2017.
//  Copyright © 2017 15NHP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


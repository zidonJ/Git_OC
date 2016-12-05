//
//  AppDelegate.h
//  MyFirstCoreData
//
//  Created by zidon on 15/5/11.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end


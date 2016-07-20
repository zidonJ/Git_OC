//
//  FriendListViewController.h
//  MyXmpp
//
//  Created by zidon on 15/5/8.
//  Copyright (c) 2015年 zidon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FriendListViewController : UIViewController<NSFetchedResultsControllerDelegate>

{
    NSFetchedResultsController *_fetchedResultsController;
}

@end

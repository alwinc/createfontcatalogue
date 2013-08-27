//
//  crtAppDelegate.h
//  Font catalogue
//
//  Created by Alwin Chin on 13/08/13.
//  Copyright (c) 2013 creategroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface crtAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

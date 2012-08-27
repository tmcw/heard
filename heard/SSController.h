//
//  SSController.h
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <Underscore.m/Underscore.h>

@interface SSController : NSObject <NSApplicationDelegate> {
    NSManagedObjectContext *managedObjectContext;
}
// Configuration
@property (strong) NSUserDefaults *prefs;
@property (strong) NSWindowController *aboutController;

// UI
@property (strong) NSStatusItem *statusItem;
@property (strong) NSMenu *menu;
@property (strong) NSMenuItem *quitMI;
@property (strong) NSMenuItem *aboutMI;
@property (strong) NSMenuItem *exportMI;
@property (strong) NSImage *tiny;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)export;

@end
//
//  SSController.h
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SSPrefController.h"

@interface SSController : NSObject <NSApplicationDelegate>
// Configuration
@property (strong) NSUserDefaults *prefs;
@property (strong) SSPrefController *prefController;

// UI
@property (strong) NSStatusItem *statusItem;
@property (strong) NSMenu *menu;
@property (strong) NSMenuItem *quitMI;
@property (strong) NSMenuItem *prefMI;
@property (strong) NSMenuItem *aboutMI;
@property (strong) NSImage *tiny;

// The log
@property (strong) NSString *logPath;
@property (strong) NSString *dateString;
@property (strong) NSFileHandle *output;

// Location
/*
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
 */
@end
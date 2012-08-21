//
//  SSController.h
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSController : NSObject <NSApplicationDelegate>
    
    // UI
    @property (strong) NSStatusItem *statusItem;
    @property (strong) NSMenu *menu;
    @property (strong) NSMenuItem *quitMI;
    @property (strong) NSMenuItem *aboutMI;
    @property (strong) NSImage *tiny;
    
    // Not UI
    @property (strong) NSString *logPath;
    @property (strong) NSString *dateString;
    
    @property (strong) NSFileHandle *output;
    
    // Location
    @property (nonatomic, strong) CLLocationManager *locationManager;
@end
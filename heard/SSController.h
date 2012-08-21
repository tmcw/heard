//
//  SSController.h
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSController : NSObject <NSApplicationDelegate>
    
    // UI
    @property (strong) NSStatusItem *statusItem;
    @property (weak) NSMenu *menu;
    @property (weak) NSMenuItem *quitMI;
    @property (weak) NSMenuItem *aboutMI;
    @property (weak) NSImage *tiny;
    
    // Not UI
    @property (weak) NSString *logPath;
    @property (weak) NSString *dateString;
    
    @property (strong) NSFileHandle *output;

@end
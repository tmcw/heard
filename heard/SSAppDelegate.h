//
//  SSAppDelegate.h
//  heard
//
//  Created by Tom MacWright on 8/20/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SSAppDelegate : NSObject {
    // UI
    NSStatusItem *statusItem;
    NSMenu *menu;
    NSMenuItem *quitMI;
    NSMenuItem *aboutMI;
    NSImage *tiny;
    
    // Not UI
    NSString *logPath;
    NSString *dateString;
    
    NSFileHandle *output;
}
@property (assign) IBOutlet NSWindow *window;
// Not UI
@end

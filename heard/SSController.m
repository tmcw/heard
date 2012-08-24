//
//  SSController.m
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSController.h"
#import "SSPrefController.h"

@implementation SSController

@synthesize statusItem = _statusItem;
// @synthesize locationManager;

- (id) init {
    self = [super init];
    if (self)
    {
        NSString* tinyName = [[NSBundle mainBundle]
                              pathForResource:@"heard-tiny"
                              ofType:@"png"];
        self.tiny = [[NSImage alloc] initWithContentsOfFile:tinyName];
        self.menu = [[NSMenu alloc] init];
        
        // Set up my status item
        self.statusItem = [[NSStatusBar systemStatusBar]
                           statusItemWithLength:NSVariableStatusItemLength];
        
        [self.statusItem setMenu:self.menu];
        [self.statusItem setToolTip:@"heard"];
        [self.statusItem setImage:self.tiny];
        [self.statusItem setHighlightMode:YES];
        
        // Set up the menu
        self.prefMI = [[NSMenuItem alloc]
                       initWithTitle:NSLocalizedString(@"Preferences...",@"")
                       action:@selector(prefWindow)
                       keyEquivalent:@","];
        [self.prefMI setTarget:self];
        
        // Set up the menu
        self.quitMI = [[NSMenuItem alloc]
                       initWithTitle:NSLocalizedString(@"Quit",@"")
                       action:@selector(terminate:)
                       keyEquivalent:@""];
        
        [self.menu addItem:self.prefMI];
        [self.menu addItem:self.quitMI];
    }
    
    self.logPath = [[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"];
    
    self.output = [NSFileHandle
                   fileHandleForWritingAtPath:self.logPath];
    
    
    if (!self.logPath) {
        [self prefWindow];
    } else if (self.output == nil) {
        BOOL success = [[NSFileManager defaultManager]
                        createFileAtPath:self.logPath
                        contents:[@"minute,artist,song,album,duration,id\n" dataUsingEncoding:NSUTF8StringEncoding]
                        attributes:nil];
        
        if (success == YES) {
            self.output = [NSFileHandle
                           fileHandleForWritingAtPath:self.logPath];
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:
             [NSString stringWithFormat:@"Couldn't initialize log at %@. Choose a new path.",
              self.logPath]];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert addButtonWithTitle:@"Ok"];
            [alert runModal];
            [self prefWindow];
        }
    }
    
    
    if (!self.logPath || self.output == nil) {
        [self prefWindow];
    }
    // Insert code here to initialize your application
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(onPlayerInfo:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    return self;
}


- (void)prefWindow
{
    // NSLog(@"Opening pref window");
    if (!self.prefController) {
        self.prefController = [[SSPrefController alloc] initWithWindowNibName:@"PrefWindow"];
    }
    
    [self.prefController showWindow:self];
}

- (void)onPlayerInfo:(NSNotification*)note
{
    NSDictionary* newtrack = note.userInfo;
    [self.output seekToEndOfFile];
    [self.output writeData:[[NSString
                             stringWithFormat:@"%d,\"%@\",\"%@\",\"%@\",%d,%d\n",
                             (int) [[NSDate date] timeIntervalSince1970],
                             [[newtrack objectForKey:@"Artist"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                             [[newtrack objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                             [[newtrack objectForKey:@"Album"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                             [[newtrack objectForKey:@"Total Time"] longLongValue] / 1000,
                             [[newtrack objectForKey:@"PersistentID"] longLongValue] / 1000

                             ]
                            dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
//
//  SSController.m
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSController.h"

@implementation SSController

@synthesize statusItem = _statusItem;
// @synthesize locationManager;

- (id) init {
    self = [super init];
    if (self)
    {
        /* NSString* tinyName = [[NSBundle mainBundle]
         pathForResource:@"heard-tiny"
         ofType:@"png"];
         
         self.tiny = [[NSImage alloc] initWithContentsOfFile:tinyName];
         */
        self.tiny = [NSImage imageNamed:@"heard-tiny"];
        self.menu = [[NSMenu alloc] init];
        
        // Set up my status item
        self.statusItem = [[NSStatusBar systemStatusBar]
                           statusItemWithLength:NSVariableStatusItemLength];
        
        [self.statusItem setMenu:self.menu];
        [self.statusItem setToolTip:@"heard"];
        [self.statusItem setImage:self.tiny];
        [self.statusItem setHighlightMode:YES];
        
        /*
         // Set up the menu
         self.prefMI = [[NSMenuItem alloc]
         initWithTitle:NSLocalizedString(@"Preferences...",@"")
         action:@selector(prefWindow)
         keyEquivalent:@""];
         [self.prefMI setTarget:self];
         */
        
        // Set up the menu
        self.aboutMI = [[NSMenuItem alloc]
                        initWithTitle:NSLocalizedString(@"About",@"")
                        action:@selector(about)
                        keyEquivalent:@""];
        [self.aboutMI setTarget:self];
        
        // Set up the menu
        self.quitMI = [[NSMenuItem alloc]
                       initWithTitle:NSLocalizedString(@"Quit",@"")
                       action:@selector(terminate:)
                       keyEquivalent:@""];
        
        // [self.menu addItem:self.prefMI];
        [self.menu addItem:self.aboutMI];
        [self.menu addItem:self.quitMI];
    }
    
    /*
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
     
     */
    // Insert code here to initialize your application
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(onPlayerInfo:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    return self;
}

- (void)about
{
    NSLog(@"Showing about window");
    NSApplication *app = [NSApplication sharedApplication];
    [app orderFrontStandardAboutPanel:self];
    NSLog(@"Window shown");
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)onPlayerInfo:(NSNotification*)note
{
    NSDictionary* newtrack = note.userInfo;
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Play"
                                              inManagedObjectContext:moc];
    
    [entityDescription setValue:[newtrack objectForKey:@"Name"] forKey:@"name"];
    [entityDescription setValue:[newtrack objectForKey:@"Artist"] forKey:@"artist"];
    [entityDescription setValue:[
                                 NSNumber numberWithLongLong:[
                                                              [newtrack objectForKey:@"PersistentID"] longLongValue]]
                         forKey:@"id"];
    [entityDescription setValue:[NSDate date] forKey:@"minute"];
    [entityDescription setValue:[newtrack objectForKey:@"Total Time"] forKey:@"duration"];
}

@end
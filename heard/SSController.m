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
@synthesize locationManager;

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
        self.quitMI = [[NSMenuItem alloc]
                   initWithTitle:NSLocalizedString(@"Quit",@"")
                   action:@selector(terminate:)
                   keyEquivalent:@""];
        
        [self.menu addItem:self.quitMI];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.logPath = [@"~/log/songs.csv"
               stringByExpandingTildeInPath];
    
    
    NSString *logDirPath = [@"~/log/"
                            stringByExpandingTildeInPath];
    
    self.output = [NSFileHandle
              fileHandleForWritingAtPath:self.logPath];
    
    if (self.output == nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Quit"];
        [alert setMessageText:@"It looks like this is the first time you're\
         using minute-agent."];
        [alert setInformativeText:[NSString stringWithFormat:@"Click OK to create %@.", self.logPath]];
        [alert setAlertStyle:NSWarningAlertStyle];
        NSInteger result = [alert runModal];
        if (result == 1000) {
            // create directory
            NSFileManager *filemgr;
            
            filemgr = [NSFileManager defaultManager];
            [filemgr createDirectoryAtPath:logDirPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
            BOOL success = [filemgr
                            createFileAtPath:self.logPath
                            contents:[@"minute,artist,song\n" dataUsingEncoding:NSUTF8StringEncoding]
                            attributes:nil];
            
            if (success == YES) {
                self.output = [NSFileHandle
                          fileHandleForWritingAtPath:self.logPath];
            } else {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:@"Could not create file."];
                [alert setAlertStyle:NSWarningAlertStyle];
                [alert addButtonWithTitle:@"Quit"];
                [alert runModal];
                [NSApp terminate:self];
            }
        } else {
            [NSApp terminate:self];
        }
    }
    // Insert code here to initialize your application
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(onPlayerInfo:)
                                                            name:@"com.apple.iTunes.playerInfo"
                                                          object:nil];
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.lat = [newLocation coordinate].latitude;
    self.lon = [newLocation coordinate].longitude;
    NSLog(@"Location: %@", [newLocation description]);
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)onPlayerInfo:(NSNotification*)note
{
    NSDictionary* newtrack = note.userInfo;
    [self.output seekToEndOfFile];
    [self.output writeData:[[NSString
                        stringWithFormat:@"%f,\"%@\",\"%@\",%@,%@\n",
                        floor([[NSDate date] timeIntervalSince1970]),
                        [[newtrack objectForKey:@"Artist"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                        [[newtrack objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                        self.lon,
                        self.lat
                        ]
                       dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
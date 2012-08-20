//
//  SSAppDelegate.m
//  heard
//
//  Created by Tom MacWright on 8/20/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    logPath = [@"~/log/songs.csv"
               stringByExpandingTildeInPath];
    
    NSString *logDirPath = [@"~/log/"
                            stringByExpandingTildeInPath];
    
    output = [NSFileHandle
              fileHandleForWritingAtPath:logPath];
    
    if (output == nil) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Quit"];
        [alert setMessageText:@"It looks like this is the first time you're\
         using minute-agent."];
        [alert setInformativeText:[NSString stringWithFormat:@"Click OK to create %@.", logPath]];
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
                            createFileAtPath:logPath
                            contents:[@"minute,artist,song\n" dataUsingEncoding:NSUTF8StringEncoding]
                            attributes:nil];
            
            if (success == YES) {
                output = [NSFileHandle
                          fileHandleForWritingAtPath:logPath];
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
}

-(void)onPlayerInfo:(NSNotification*)note
{
    NSDictionary* newtrack = note.userInfo;
    [output seekToEndOfFile];
    [output writeData:[[NSString
                        stringWithFormat:@"%f,\"%@\",\"%@\"\n",
                        floor([[NSDate date] timeIntervalSince1970]),
                        [[newtrack objectForKey:@"Artist"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""],
                        [[newtrack objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""]
                        ]
                       dataUsingEncoding:NSUTF8StringEncoding]];
}

@end

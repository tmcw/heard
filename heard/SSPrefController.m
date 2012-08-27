//
//  SSPrefController.m
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSPrefController.h"

@implementation SSPrefController
- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                          object:[NSUserDefaults standardUserDefaults]
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *notification)
         {
             NSUserDefaults *defaults = [notification object];
         }];
    }
    return self;
}

- (IBAction)doSaveAs:(id)pId; {
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // Configure your panel the way you want it
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [[NSUserDefaults standardUserDefaults] setValue:[[panel URL] absoluteString]
                                                     forKey:@"FilePath"];
        }
    }];
}


- (IBAction)openContaining:(id)pId; {
    NSLog(@"Opening file at %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"]);
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"])
    {
        /* via https://trac.transmissionbt.com/changeset/9342/trunk/macosx/TorrentCell.m */
        [[NSWorkspace sharedWorkspace]
         selectFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"]
         inFileViewerRootedAtPath:nil];
    }
}

#pragma mark -
- (NSString *)currentFilePath
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"])
    {
        return (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"];
    }
    return @"";
}
#pragma mark -
#pragma mark NSWindowDelegate

- (void)awakeFromNib
{
    [[self window] center];
}
@end
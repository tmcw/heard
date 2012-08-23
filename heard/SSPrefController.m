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
    NSLog(@"doSaveAs");
    NSSavePanel *tvarNSSavePanelObj	= [NSSavePanel savePanel];
    long tvarInt	= [tvarNSSavePanelObj runModal];
    
    if(tvarInt == NSOKButton){
     	NSLog(@"doSaveAs we have an OK button");
        [[NSUserDefaults standardUserDefaults] setValue:[tvarNSSavePanelObj filename] forKey:@"FilePath"];
    } else if(tvarInt == NSCancelButton) {
     	NSLog(@"doSaveAs we have a Cancel button");
     	return;
    } else {
     	NSLog(@"doSaveAs tvarInt not equal 1 or zero = %3l",tvarInt);
     	return;
    } // end if
    
    /*
    NSString * tvarDirectory = [tvarNSSavePanelObj directory];
    NSLog(@"doSaveAs directory = %@",tvarDirectory);
    
    NSString * tvarFilename = [tvarNSSavePanelObj filename];
    NSLog(@"doSaveAs filename = %@",tvarFilename);
     */
    
} // end doSaveAs

#pragma mark -
- (NSString *)currentFilePath
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"])
    {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"FilePath"];
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
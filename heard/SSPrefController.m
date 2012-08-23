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
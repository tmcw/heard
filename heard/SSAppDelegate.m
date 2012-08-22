//
//  SSAppDelegate.m
//  heard
//
//  Created by Tom MacWright on 8/20/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSController.h"
#import "SSPrefController.h"

@implementation SSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.ss = [[SSController alloc] init];
}
@end

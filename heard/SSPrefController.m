//
//  SSPrefController.m
//  heard
//
//  Created by Tom MacWright on 8/21/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import "SSPrefController.h"

@implementation SSPrefController
- (id)init
{
    self = [super initWithWindowNibName:@"PrefWindow"];
    if(self)
    {
        //initialize stuff
    }
    return self;
}
//this is a simple override of -showWindow: to ensure the window is always centered
-(IBAction)showWindow:(id)sender
{
    [super showWindow:sender];
    [[self window] center];
    [[self window] makeKeyAndOrderFront:sender];
}
@end
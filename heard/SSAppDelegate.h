//
//  SSAppDelegate.h
//  heard
//
//  Created by Tom MacWright on 8/20/12.
//  Copyright (c) 2012 Tom MacWright. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSController.h"


@interface SSAppDelegate : NSObject <NSApplicationDelegate>
    @property (strong) SSController *ss;
@end
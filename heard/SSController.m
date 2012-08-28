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
        self.tiny = [NSImage imageNamed:@"heard-tiny"];
        self.menu = [[NSMenu alloc] init];
        
        // Set up my status item
        self.statusItem = [[NSStatusBar systemStatusBar]
                           statusItemWithLength:NSVariableStatusItemLength];
        
        [self.statusItem setMenu:self.menu];
        [self.statusItem setToolTip:@"heard"];
        [self.statusItem setImage:self.tiny];
        [self.statusItem setHighlightMode:YES];
        
        self.exportMI = [[NSMenuItem alloc] initWithTitle:@"Export"
                                                   action:@selector(export)
                                            keyEquivalent:@""];
        [self.exportMI setTarget:self]; // or whatever target you want
        
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
        
        [self.menu addItem:self.exportMI];
        [self.menu addItem:self.aboutMI];
        [self.menu addItem:self.quitMI];
    }
    
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

- (void)export
{
    NSLog(@"Showing exporting");
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"json"]];
    if ([savePanel runModal] == NSOKButton) {
        // panel.URL;
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Play"
                                       inManagedObjectContext:moc];
        [request setEntity:entity];
        NSArray *array = _array([moc executeFetchRequest:request error:&error])
        .map(^NSDictionary *(NSManagedObject *play) {
            NSDictionary* dict = [play committedValuesForKeys:nil];
            [dict setValue:[NSNumber numberWithDouble:[[dict valueForKey:@"minute"] timeIntervalSince1970]] forKey:@"minute"];
            return dict;
        }).unwrap;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        [jsonData writeToURL:savePanel.URL atomically:TRUE];
    }
    NSLog(@"Window shown");
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSUInteger)songsCount
{
    NSLog(@"Counting");
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Play"
                                   inManagedObjectContext:moc];
    [request setEntity:entity];
    NSInteger c = [moc countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"here, %@", error);
    }
    return c;
}

- (void)onPlayerInfo:(NSNotification*)note
{
    NSDictionary* newtrack = note.userInfo;
    
    NSLog(@"Logging note");
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Play"
                                              inManagedObjectContext:moc];
    
    [entityDescription setValue:[newtrack objectForKey:@"Name"] forKey:@"name"];
    [entityDescription setValue:[newtrack objectForKey:@"Album"] forKey:@"album"];
    [entityDescription setValue:[newtrack objectForKey:@"Artist"] forKey:@"artist"];
    [entityDescription setValue:[newtrack objectForKey:@"Rating"] forKey:@"rating"];
    [entityDescription setValue:[[newtrack objectForKey:@"PersistentID"]stringValue] forKey:@"id" ];
    [entityDescription setValue:[NSDate date] forKey:@"minute"];
    [entityDescription setValue:[newtrack objectForKey:@"Total Time"] forKey:@"duration"];
    
    
    NSError *error = nil;
    [moc save:&error];
    
    [self.exportMI setTitle:[NSString stringWithFormat:@"Export (%lu)",
                             [self songsCount]]];
    
    if (error != nil) {
        NSLog(@"Error: could not save");
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to export plays"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please file an issue on GitHub"];
        [alert runModal];
    }
}

@end
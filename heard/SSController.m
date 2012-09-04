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

- (id) init {
    self = [super init];
    if (self)
    {
        self.tiny = [NSImage imageNamed:@"heard-tiny"];
        self.menu = [[NSMenu alloc] init];
        
        self.statusItem = [[NSStatusBar systemStatusBar]
                           statusItemWithLength:NSVariableStatusItemLength];
        
        [self.statusItem setMenu:self.menu];
        [self.statusItem setToolTip:@"heard"];
        [self.statusItem setImage:self.tiny];
        [self.statusItem setHighlightMode:YES];
        
        self.exportMI = [[NSMenuItem alloc] initWithTitle:@"Export"
                        action:@selector(export)
                        keyEquivalent:@""];
        [self.exportMI setTarget:self];
        
        self.aboutMI = [[NSMenuItem alloc]
                        initWithTitle:NSLocalizedString(@"About",@"")
                        action:@selector(about)
                        keyEquivalent:@""];
        [self.aboutMI setTarget:self];
        
        self.quitMI = [[NSMenuItem alloc]
                       initWithTitle:NSLocalizedString(@"Quit",@"")
                       action:@selector(terminate:)
                       keyEquivalent:@""];
        
        [self.menu addItem:self.exportMI];
        [self.menu addItem:self.aboutMI];
        [self.menu addItem:self.quitMI];
    }
    
    // Start listening to iTunes plays
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
    [app activateIgnoringOtherApps:YES];
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
        NSError *error = nil;
        
        // Create request that will fetch all plays
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
            entityForName:@"Play"
            inManagedObjectContext:moc];
        [request setEntity:entity];
        
        // Fetch the entries, cast them into dictionaries with unix
        // timestamps
        NSArray *array = _array([moc executeFetchRequest:request error:&error])
        .map(^NSDictionary *(NSManagedObject *play) {
            NSDictionary* dict = [play committedValuesForKeys:nil];
            [dict setValue:[NSNumber numberWithDouble:[[dict valueForKey:@"minute"] timeIntervalSince1970]] forKey:@"minute"];
            return dict;
        }).unwrap;
        
        // Create a data blob of encoded plays
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
            options:NSJSONWritingPrettyPrinted
            error:&error];
        
        if (error != nil) {
            NSLog(@"JSON could not be encoded");
        }
        
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
        NSLog(@"Unable to cound plays, %@", error);
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to count plays"
            defaultButton:@"OK"
            alternateButton:nil
            otherButton:nil
            informativeTextWithFormat:@"Please file an issue on GitHub: %@", error];
        [alert runModal];
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
    [entityDescription setValue:[NSString stringWithFormat:@"%qX",
                                 [[newtrack objectForKey:@"PersistentID"] longLongValue]] forKey:@"id"];
    [entityDescription setValue:[NSDate date] forKey:@"minute"];
    [entityDescription setValue:[newtrack objectForKey:@"Total Time"] forKey:@"duration"];
    
    NSError *error = nil;
    [moc save:&error];
    
    [self.exportMI setTitle:[NSString stringWithFormat:@"Export (%lu)",
                             [self songsCount]]];
    
    if (error != nil) {
        NSLog(@"Error: could not save, %@", error);
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to save play"
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"Please file an issue on GitHub"];
        [alert runModal];
    }
}

@end
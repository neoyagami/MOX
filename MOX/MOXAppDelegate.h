//
//  MOXAppDelegate.h
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MOXAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
-(IBAction)getXML:(id)sender;
-(IBAction)DisplayConf:(id)sender;
-(IBAction)FastAudit:(id)sender;
@end

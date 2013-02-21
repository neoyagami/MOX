//
//  MoxConfigWindow.h
//  MOX
//
//  Created by Victor Lucero on 17-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOXConfigData.h"
#import "MOXMasterViewController.h"
@interface MoxConfigWindow : NSWindowController
@property ( strong) IBOutlet NSTextField *Ruta;
@property ( strong) IBOutlet NSTextField *Snap;
@property ( strong) IBOutlet NSTextField *RutaMameBin;
@property ( strong) IBOutlet NSTextField *Globaldir;
@property (strong) IBOutlet NSPopUpButton *FullorWindow;
@property (strong) IBOutlet NSPopUpButton *SampleRate;
@property (strong) IBOutlet NSPopUpButton *Delay;
@property (strong) IBOutlet NSButton *CheckBoxKeepAspectorNO;
@property (strong) MOXMasterViewController *ParentObject;
@property (strong) MOXConfigData *ConfigDataWindow;
- (IBAction)MoxNuevaRutaRoms:(id)sender ;
- (IBAction)BtnClose:(id)sender;
-(IBAction)FullScreen:(id)sender;
-(IBAction)KeepAspectClick:(id)sender;
-(IBAction)SelectSampleRate:(id)sender;
-(IBAction)SelectDelay:(id)sender ;
-(void)StoreConfig ;
@end

//
//  MoxConfigWindow.m
//  MOX
//
//  Created by Victor Lucero on 17-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import "MoxConfigWindow.h"

@interface MoxConfigWindow ()

@end

@implementation MoxConfigWindow
- (IBAction)BtnClose:(id)sender {
    [self.ParentObject Close_Config ];
}
- (IBAction)MoxNuevaRutaRoms:(id)sender {
   
    
    
    NSLog(@"%@",[sender identifier]);
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseDirectories:true];
    
   
   
    [openDlg setCanChooseFiles:[[sender identifier] isEqualToString:@"MameBin"]];
                    
            if ([openDlg runModal]==NSOKButton) {
        NSArray * Array = [openDlg URLs];
        NSURL * Url=[Array objectAtIndex:0];
        NSString * TmpString = [[Url absoluteString] stringByReplacingOccurrencesOfString:@"file://localhost" withString:@"" ];
       
        if ([[sender identifier] isEqualToString:@"MameBin"]) {
            [self.RutaMameBin setStringValue:TmpString];
            [self.ConfigDataWindow setMameBinPath:TmpString];
        }
        if ([[sender identifier] isEqualToString:@"Roms"]) {
            [self.Ruta setStringValue:TmpString];
            [self.ConfigDataWindow setRomPath:TmpString];

        }
        if ([[sender identifier] isEqualToString:@"Snap"]) {
            [self.Snap setStringValue:TmpString];
            [self.ConfigDataWindow setSnapPath:TmpString];

        }

        if ([[sender identifier] isEqualToString:@"Global"]) {
            [self.Globaldir setStringValue:TmpString];
            [self.ConfigDataWindow setGlobalDir:TmpString];

        }

                [self StoreConfig];
        
    }


}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSLog(@"CARGO");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.Ruta setStringValue:[self.ConfigDataWindow RomPath]];
    [self.Globaldir setStringValue:[self.ConfigDataWindow GlobalDir]   ];
    [self.RutaMameBin setStringValue:[self.ConfigDataWindow MameBinPath]];
    [self.Snap setStringValue:[self.ConfigDataWindow SnapPath]  ];
    int SR=0;
    switch ([self.ConfigDataWindow SampleRate]) {
        case 11025:
            SR=0;
            break;
        case 22050:
            SR=1;
            break;
        case 44075:
            SR=2;
            break;
        case 48100:
            SR=3;
            break;
        default:
            break;
    }
    
    NSLog(@"%@",[self.ConfigDataWindow keepAspect]?@"YES":@"NO");

    [self.SampleRate selectItemAtIndex:SR];
    
    if ([self.ConfigDataWindow FullScreen]) {
        [self.FullorWindow selectItemAtIndex:0];
    } else {
        [self.FullorWindow selectItemAtIndex:1];

    }
    if ([self.ConfigDataWindow keepAspect]) {
        [self.CheckBoxKeepAspectorNO setState:NSOnState];
    } else {
        [self.CheckBoxKeepAspectorNO setState:NSOffState];

    }
    
    
    
    
}
-(IBAction)FullScreen:(id)sender {
    NSPopUpButton * Button=(NSPopUpButton * )sender;
    if ([[Button titleOfSelectedItem] isEqualToString:@"Ventana"  ]) {
        [self.ConfigDataWindow setFullScreen:NO];
    } else {
        [self.ConfigDataWindow setFullScreen:YES];

    }

    [self StoreConfig];
    
}


-(IBAction)KeepAspectClick:(id)sender {
    NSButton * Checkbox=(NSButton *)sender;
    if ([Checkbox state]==NSOnState) {
        [self.ConfigDataWindow setKeepAspect:YES];
    } else {
        [self.ConfigDataWindow setKeepAspect:NO];

    }
    [self StoreConfig];
}
-(IBAction)SelectDelay:(id)sender {
    NSPopUpButton * Boton= (NSPopUpButton *) sender;
   
    [self.ConfigDataWindow setDelay:[Boton indexOfSelectedItem]];
    
}

-(IBAction)SelectSampleRate:(id)sender {
    NSPopUpButton * PopUp = (NSPopUpButton *) sender;
    int SR=0;
    switch ([PopUp indexOfSelectedItem]) {
        case 0:
            SR=11025;
            break;
        case 1:
            SR=22050;
            break;
        case 2:
            SR=44075;
            break;
        case 3:
            SR=48100;
            break;
            
        default:
            break;
    }
    
[self.ConfigDataWindow setSampleRate:SR ];

    [self StoreConfig];
}

-(void)StoreConfig {
    NSMutableDictionary * StoreDic=[NSMutableDictionary dictionary];
    [StoreDic setObject:self.ConfigDataWindow.MameBinPath forKey:@"MameBinPath"];
    [StoreDic setObject:self.ConfigDataWindow.RomPath forKey:@"RomPath"];
    [StoreDic setObject:self.ConfigDataWindow.SnapPath forKey:@"SnapPath"];
    [StoreDic setObject:self.ConfigDataWindow.GlobalDir forKey:@"GlobalDir"];
    [StoreDic setObject:[self.ConfigDataWindow FullScreen]?@"YES":@"NO" forKey:@"FullScreen"];
    [StoreDic setObject:[self.ConfigDataWindow keepAspect]?@"YES":@"NO" forKey:@"keepAspect"];
    [StoreDic setObject:[NSString stringWithFormat:@"%lu", [self.ConfigDataWindow SampleRate]] forKey:@"SampleRate"];
    [StoreDic setObject:[NSString stringWithFormat:@"%lu", [self.ConfigDataWindow Delay]] forKey:@"Delay"];
    [StoreDic setObject:[self.ParentObject ShowGood]?@"YES":@"NO" forKey:@"ShowGood"];
    [StoreDic setObject:[self.ParentObject ShowFavorites]?@"YES":@"NO" forKey:@"ShowFavorites"];


    
    [NSKeyedArchiver archiveRootObject:StoreDic toFile:[[NSBundle mainBundle] pathForResource:@"paths" ofType:@"cfg" ]];

}

@end

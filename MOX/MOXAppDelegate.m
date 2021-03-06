//
//  MOXAppDelegate.m
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import "MOXAppDelegate.h"
#import "MOXMasterViewController.h"
#import "MoxGame.h"
#import "MOXConfigData.h"
#import "TBXML.h"
#import "PCFadedImageView.h"

@interface MOXAppDelegate()
@property (nonatomic,strong) IBOutlet MOXMasterViewController *MOXMasterViewC ;

@end


@implementation MOXAppDelegate
-(IBAction)DisplayConf:(id)sender{
    [self.MOXMasterViewC Show_Config:nil];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDictionary *Config=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:@"gamelist" ofType:@"cfg"]];
  
    NSArray * ArrayTemporal=[Config valueForKey:@"Lista"];
    NSMutableArray * JuegosFromFile=[[NSMutableArray alloc] initWithArray:ArrayTemporal];
    
    NSDictionary *Paths=[NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"paths" ofType:@"cfg"]];
        
    
    self.MOXMasterViewC = [[MOXMasterViewController alloc] initWithNibName:@"MOXMasterViewController" bundle:nil];
    self.MOXMasterViewC.MoxConfig = [[MOXConfigData alloc] initWithValues:@"" GlobalPath:@"" RomPath:@"" SnapPath:@""  ];
   
    
    
    
    [self.MOXMasterViewC.MoxConfig setMameBinPath:[Paths valueForKey:@"MameBinPath"]!=nil?[Paths valueForKey:@"MameBinPath"]:@"" ];
    [self.MOXMasterViewC.MoxConfig setRomPath:[Paths valueForKey:@"RomPath"]!=nil?[Paths valueForKey:@"RomPath"]:@""];
    [self.MOXMasterViewC.MoxConfig setSnapPath:[Paths valueForKey:@"SnapPath"]!=nil?[Paths valueForKey:@"SnapPath"]:@""];
    [self.MOXMasterViewC.MoxConfig setGlobalDir:[Paths valueForKey:@"GlobalDir"]!=nil?[Paths valueForKey:@"GlobalDir"]:@""];
    NSString * tmpSTR=[Paths valueForKey:@"SampleRate"] ;
    
    [self.MOXMasterViewC.MoxConfig setSampleRate:[tmpSTR integerValue]   ];
    NSString * TmpFs=[Paths valueForKey:@"FullScreen"];
    [self.MOXMasterViewC.MoxConfig setFullScreen:[TmpFs isEqualToString:@"YES"] ];
    NSString * tmpKa=[Paths valueForKey:@"keepAspect"];
    [self.MOXMasterViewC.MoxConfig setKeepAspect:[tmpKa isEqualToString:@"YES"]];
    NSString *tmpDelay=[Paths valueForKey:@"Delay"];
    [self.MOXMasterViewC.MoxConfig setDelay:[tmpDelay integerValue]];
    NSString *tmpShowGood=[Paths valueForKey:@"ShowGood"];
     self.MOXMasterViewC.ShowGood=[tmpShowGood isEqualToString:@"YES"];
    NSString *tmpShowFavorites=[Paths valueForKey:@"ShowFavorites"];
    self.MOXMasterViewC.ShowFavorites=[tmpShowFavorites isEqualToString:@"YES"];
    
    
    
    
    self.MOXMasterViewC.MoxGamesList =[[NSMutableArray alloc ] init ];
    //[self.MOXMasterViewC setMoxGamesList:Juegos];

    self.MOXMasterViewC.MoxGameListNF = [[NSMutableArray alloc]initWithArray:JuegosFromFile]  ;
    //()[self.MOXMasterViewC setMoxGameListNF:Juegos];
    
    self.MOXMasterViewC.MoxGameListPreFilter = [[NSMutableArray alloc] init];
    
    [self.MOXMasterViewC ApplyFilters];
    
    
    [self.window.contentView addSubview:self.self.MOXMasterViewC.view];
    self.MOXMasterViewC.view.frame = ((NSView*)self.window.contentView).bounds;
    [self.MOXMasterViewC setParentWindow:[self window]];
    [self.MOXMasterViewC.Tabla setDoubleAction:@selector(double_click:)];
    [self.MOXMasterViewC.Tabla setAction:@selector(single:)];
    if ([self.MOXMasterViewC ShowGood]) {
        [self.MOXMasterViewC.Checkbox setState:NSOnState];
    } else {
        [self.MOXMasterViewC.Checkbox setState:NSOffState];

    }
    if ([self.MOXMasterViewC ShowFavorites]) {
        [self.MOXMasterViewC.CheckboxFav setState:NSOnState];
    } else {
        [self.MOXMasterViewC.CheckboxFav setState:NSOffState];
        
    }
    
  //  NSLog(@"%p %p  ",[self.MOXMasterViewC.MoxGamesList objectAtIndex:0],[self.MOXMasterViewC.MoxGameListNF objectAtIndex:0]  );
    
}
-(IBAction)getXML:(id)sender {
    [self.MOXMasterViewC localProcessXMLFromBinary];
}



-(void)double_click:(id)sender
{
    [self.MOXMasterViewC double_click:sender ];
}
-(void)single:(id)sender
{
    [self.MOXMasterViewC GameSelected:sender];
}
-(IBAction)FastAudit:(id)sender {
    NSLog(@"fastaudit");
    [self.MOXMasterViewC RomFastAudit];
}

@end

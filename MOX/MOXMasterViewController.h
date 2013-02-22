//
//  MOXMasterViewController.h
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOXConfigData.h"

@interface MOXMasterViewController : NSViewController
@property (strong ) NSMutableArray *MoxGamesList;
@property (strong) NSMutableArray *MoxGameListPreFilter;
@property (strong) IBOutlet NSButton *Checkbox;
@property (strong) IBOutlet NSButton *CheckboxFav;

@property (strong) NSMutableArray *MoxGameListNF;
@property (strong) IBOutlet NSButton *BotonReload;
@property (strong) IBOutlet NSTableView *Tabla;
@property (strong) IBOutlet NSSearchField *FilterField;
@property (strong) MOXConfigData *MoxConfig;
@property (strong) IBOutlet NSImageView *ImageVIEW;
@property (strong) NSMutableArray *DirList;
@property (assign) BOOL ShowGood;
@property (assign) BOOL ShowFavorites;
-(IBAction)Click_Checkbox:(id)sender;
-(IBAction)Show_Config:(id)Sender;
-(IBAction)Change_filter:(id)sender;
-(IBAction)GameSelected:(id)sender;
-(void)double_click:(id)sender;
-(void) RomFastAudit;
-(void) Close_Config;
-(void) ApplyFilters;
-(void) localProcessXMLFromBinary ;
-(NSView *) tableView: (NSTableView *) tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row ;
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView ;
@end

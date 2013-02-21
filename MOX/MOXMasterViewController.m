//
//  MOXMasterViewController.m
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import "MOXMasterViewController.h"
#import "MoxGame.h"
#import "MoxConfigWindow.h"
#import "MOXConfigData.h"
#import "TBXML.h"
@interface MOXMasterViewController ()
@property (nonatomic,strong) IBOutlet MoxConfigWindow *MoxConfigW;
@end

@implementation MOXMasterViewController

-(IBAction)Change_filter:(id)sender {
    NSLog(@"-%@ %lu",[self.FilterField stringValue],[self.MoxGameListNF count ]);
    NSString *TMPStr=[self.FilterField stringValue];
    [self.MoxGamesList removeAllObjects];

    if ([TMPStr length]==0) {
        NSLog(@"vakcio ");
        if ([self ShowGood]) {
            [self.MoxGamesList addObjectsFromArray:self.MoxGameListGood ];

        } else {
            [self.MoxGamesList addObjectsFromArray:self.MoxGameListNF ];

        }
        
    } else {
        
        NSPredicate * FS=[NSPredicate predicateWithFormat:@"Name contains[cd] %@ or Description contains[cd] %@ or Year contains[cd] %@ or Manufacturer contains[cd] %@", TMPStr , TMPStr, TMPStr, TMPStr] ;
        
        NSArray *TmpARR; //Pirate ARRay
        if ([self ShowGood]) {
            TmpARR = [self.MoxGameListGood filteredArrayUsingPredicate:FS];

        } else {
            TmpARR = [self.MoxGameListNF filteredArrayUsingPredicate:FS];
        }
        [self.MoxGamesList addObjectsFromArray:TmpARR ];
   

    }
    [self.Tabla reloadData];

   
}

-(IBAction)Show_Config:(id)Sender {

    self.MoxConfigW.ConfigDataWindow=[self.MoxConfig CopyConfig];
    
    [NSApp runModalForWindow:self.MoxConfigW.window];
   // [self.MoxConfigW showWindow:nil];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    
    self.MoxConfigW = [[MoxConfigWindow alloc] initWithWindowNibName:@"MoxConfigWindow"];
    self.MoxConfigW.ParentObject=self;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    [self.Tabla setTarget:self];
    [self.Tabla setDoubleAction:@selector(double_click:)];
    [self.Tabla setAction:@selector(GameSelected:)];
    
    return self;
}

-(NSView *) tableView: (NSTableView *) tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSTableCellView  *cellv = [tableView makeViewWithIdentifier:tableColumn.identifier  owner:self ];
    
    MoxGame *Juego=[self.MoxGamesList objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"NombreLargo"]) {
        cellv.textField.stringValue=Juego.Description;;
                
    }
    if ([tableColumn.identifier isEqualToString:@"Numero"]) {
        cellv.textField.stringValue=[NSString stringWithFormat:@"%ld",Juego.GameId];
                    
    }
    if ([tableColumn.identifier isEqualToString:@"NombreC"]) {
        MoxGame *Juego=[self.MoxGamesList objectAtIndex:row];
        cellv.textField.stringValue=Juego.Name;
                
    }
    if ([tableColumn.identifier isEqualToString:@"Year"]) {
        cellv.textField.stringValue=Juego.Year;
        
    }
    if ([tableColumn.identifier isEqualToString:@"Fabrica"]) {

        cellv.textField.stringValue=Juego.Manufacturer;
        
    }
    
    
    
    return cellv;

    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSLog(@"se disparo %lu", [self ShowGood]?[self.MoxGameListGood count]:[self.MoxGamesList count]);
    return  [self ShowGood]?[self.MoxGameListGood count]:[self.MoxGamesList count];
}

-(void) Close_Config{

    [self.MoxConfig CopyFromConfig:[self.MoxConfigW ConfigDataWindow ]];
    [NSApp stopModalWithCode:NSOKButton];
   //detenemos el modo modal
   [self.MoxConfigW.window orderOut:self];
    //escondemos la evntana

}

-(void) localProcessXMLFromBinary  {
    
    [self.MoxGameListNF removeAllObjects];
    [self.MoxGamesList removeAllObjects];

    NSLog(@"asdadsads");
    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:[self.MoxConfig MameBinPath] ];
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-listxml", nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"lanuch");
    [task launch];
    NSLog(@"fini");
    
    NSData *data;
    data = [file readDataToEndOfFile];
    NSLog(@"post load");
    //NSString *string;
    //string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog(@"post string");
    NSError *err;
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data error:&err];
    TBXMLElement *root = [tbxml rootXMLElement];
    TBXMLElement *node = root->firstChild;
    TBXMLAttribute *attr = node->firstAttribute;
    
    NSLog(@"ver element %@  attr %@ value %@" ,[TBXML elementName:node],[TBXML attributeName:attr],[TBXML valueOfAttributeNamed:@"nae" forElement:node ] );
    
    
    int Contador=0;
    for (TBXMLElement *elemento=node; elemento!=nil; elemento=elemento->nextSibling) {
        Contador++;
        
        if ([[TBXML valueOfAttributeNamed:@"isdevice" forElement:elemento ] isEqualToString:@"yes"] ) {
            continue;
        }
        
        MoxGame * Juego=[[MoxGame alloc]initWithTitle:[TBXML valueOfAttributeNamed:@"name" forElement:elemento ] Description:@"" Manufacturer:@"" Year:@"" GameId:Contador Parent:[TBXML valueOfAttributeNamed:@"cloneof" forElement:elemento ]];
       
        
        for (TBXMLElement *childs=elemento->firstChild; childs!=nil; childs=childs->nextSibling) {
            NSString *ChildType=[TBXML elementName:childs];
            NSString *Value =[TBXML textForElement:childs];
            
            if ([ChildType isEqualToString:@"description"]) {
                [Juego setDescription:Value];
            }
            if ([ChildType isEqualToString:@"manufacturer"]) {
                [Juego setManufacturer:Value];
            }
            if ([ChildType isEqualToString:@"year"]) {
                [Juego setYear:Value];
            }
            
            
        }
        [self.MoxGameListNF addObject:Juego];
        
        
        
    }
    [self StoreGameList];
    [self.MoxGamesList addObjectsFromArray:self.MoxGameListNF];
    [self.Tabla reloadData];
    
      
    
    
}

-(IBAction)Click_Checkbox:(id)sender {

    NSButton * Check = (NSButton *) sender;
    [self setShowGood:[Check state]==NSOnState];
    [self.MoxConfigW setConfigDataWindow:[self.MoxConfig CopyConfig] ];
    [self.MoxConfigW StoreConfig];
    [self.Tabla reloadData];

    
    
}

-(IBAction)GameSelected:(id)sender {
     NSTableView *v = (NSTableView *)sender;
  
    NSLog(@"sc %lu",[v selectedRow]);
    if (![v isRowSelected:[v selectedRow]])
        return ;
    
    
    MoxGame *Game=[self.MoxGamesList objectAtIndex:[v selectedRow]];
    NSString * SnapGame=[[NSString alloc] initWithFormat:@"%@/%@/0000.png",[self.MoxConfig SnapPath],[Game Name] ];
    NSImage * Imagen=[[NSImage alloc] initWithContentsOfFile:SnapGame];
    
    if (Imagen==0) {
        Imagen=[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"noimage.png"]];
                }
    
    [self.ImageVIEW setImage:Imagen];
    //[self.ImageVIEW setima ]
    
    
}

-(void)double_click:(id)sender
{
    NSTableView *v = (NSTableView *)sender;
    MoxGame *Game=[self.MoxGamesList objectAtIndex:[v selectedRow]];

    [self RunGame:[Game Name]];

}


-(void) RomFastAudit {
    NSError *Error;
    NSArray *_Dirlist=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self.MoxConfig RomPath] error:&Error ];
    NSMutableArray * Dirlist =[[NSMutableArray alloc]initWithArray:_Dirlist];
    [self.MoxGameListGood removeAllObjects];
    MoxGame *_GAME;
    NSString *_File;
    NSRange Rango;
   //se limpia todo lo que no sea un rom
    for ( long int Fn=0;Fn < [Dirlist count]; Fn++) {
        _File=[Dirlist objectAtIndex:Fn];
        Rango=[_File rangeOfString:@".zip"];
        if (Rango.length==0) {
            [Dirlist removeObjectAtIndex:Fn];
            Fn--;
        }
    }
   

    long int Fn=0;
    for (long int Gn=0; Gn<[self.MoxGameListNF count]; Gn++) {
    
        _GAME=[self.MoxGameListNF objectAtIndex:Gn];
        //NSLog(@"%lu %lu %lu",Gn,[Dirlist count],[self.MoxGameListNF count ]  );
       
        if (!(Fn < [Dirlist count])) {
            break;
        }
        _File=[Dirlist objectAtIndex:Fn];

     //   NSLog(@"%@ %@",[NSString stringWithFormat:@"%@.zip",[_GAME Name] ] , _File);
        
       
        
        switch ([_File compare:[NSString stringWithFormat:@"%@.zip",[_GAME Name] ] ]) {
            case NSOrderedAscending:
               // NSLog(@"mayor");
                Gn--;
                break;
            case NSOrderedSame:
               // NSLog(@"IGUAL");
                [self.MoxGameListGood addObject:_GAME];
                break;
            case NSOrderedDescending:
                //NSLog(@"menor");
                Fn--;
                

                break;
            default:
                break;
        }
        
    Fn++;
    }
    
    [self StoreGameList];
    
}

-(void) StoreGameList {
    NSMutableDictionary * Storedict=[NSMutableDictionary dictionary];
    [Storedict setValue:[self MoxGameListNF] forKey:@"Lista"];
    [Storedict setValue:[self MoxGameListGood] forKey:@"Good"];

    [NSKeyedArchiver archiveRootObject:Storedict toFile:[[NSBundle mainBundle] pathForResource:@"gamelist" ofType:@"cfg" ]  ];
    

}
-(void)RunGame:(NSString *)Juego {
    NSMutableArray * Opciones=[[NSMutableArray alloc]init];

    [Opciones addObject:Juego];
    
    if ([self.MoxConfig keepAspect]) {
        [Opciones addObject:@"-ka"];
    }
    
    [Opciones addObject:@"-samplerate"  ];
    [Opciones addObject:[NSString stringWithFormat:@"%lu",[self.MoxConfig SampleRate]]  ];

    if ([self.MoxConfig FullScreen]) {
        [Opciones addObject:@"-nowindow"];
    } else {
        [Opciones addObject:@"-window"];

    }
    [Opciones addObject:@"-audio_latency" ]  ;
    [Opciones addObject:[NSString stringWithFormat:@"%lu",[self.MoxConfig Delay]+1]];
    
    [Opciones addObject:@"-rp"];

    [Opciones addObject:[NSString stringWithFormat:@"%@",[self.MoxConfig RomPath]]];

    
    [Opciones addObject:@"-snapshot_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@",[self.MoxConfig SnapPath]]];

    [Opciones addObject:@"-cfg_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/cfg",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-nvram_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/nvram",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-memcard_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/memcard",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-input_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/input",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-state_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/state",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-diff_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/diff",[self.MoxConfig GlobalDir]]];
    [Opciones addObject:@"-comment_directory"];
    [Opciones addObject:[NSString stringWithFormat:@"%@/comment",[self.MoxConfig GlobalDir]]];

    
    
    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:[self.MoxConfig MameBinPath] ];
    [task setArguments: Opciones];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    NSLog(@"Run Game");
    [task launch];
    NSLog(@"EndRungame");
    
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSLog(@"%@",string);
    
    
    
}



@end

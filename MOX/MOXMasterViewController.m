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
    //NSLog(@"-%@ %lu",[self.FilterField stringValue],[self.MoxGameListNF count ]);
    NSString *TMPStr=[self.FilterField stringValue];
    [self.MoxGamesList removeAllObjects];

    if ([TMPStr length]==0) {
        //NSLog(@"vakcio ");
            [self.MoxGamesList addObjectsFromArray:self.MoxGameListPreFilter ];
    }
        NSPredicate * FS=[NSPredicate predicateWithFormat:@"Name contains[cd] %@ or Description contains[cd] %@ or Year contains[cd] %@ or Manufacturer contains[cd] %@", TMPStr , TMPStr, TMPStr, TMPStr] ;
        
        NSArray *TmpARR; //Pirate ARRay
    
    //NSLog(@"%@ ", [[self MoxGameListPreFilter] className ] );
        TmpARR = [self.MoxGameListPreFilter filteredArrayUsingPredicate:FS];
        [self.MoxGamesList addObjectsFromArray:TmpARR ];
   

    
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
    
    /*NSImageView *IV=[[NSImageView alloc] init];
    NSImage * Imagen=[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"noimage.png"]];

    [IV setBoundsSize:NSMakeSize(100, 100)];
    [IV setImage:Imagen];
    IV.frame = CGRectMake(100, 100, 100, 100);
    [self.scrollview addSubview:IV]; 
    [self.scrollview addSubview:IV];*/

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
    return  [self.MoxGamesList count];
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
    //NSLog(@"lanuch");
    [task launch];
    //NSLog(@"fini");
    
    NSData *data;
    data = [file readDataToEndOfFile];
    //NSLog(@"post load");
    //NSString *string;
    //string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    ////NSLog(@"post string");
    NSError *err;
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data error:&err];
    TBXMLElement *root = [tbxml rootXMLElement];
    TBXMLElement *node = root->firstChild;
    
    
    
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
        [Juego setFavorito:NO];
        [Juego setEncontrado:NO];
        [self.MoxGameListNF addObject:Juego];
        
        
        
    }
    [self StoreGameList];
    [self ApplyFilters];
    [self.Tabla reloadData];
    
      
    
    
}

-(IBAction)Click_Checkbox:(id)sender {

    NSButton * Check = (NSButton *) sender;
    
    if ( [ [Check identifier] isEqualToString:@"Audited" ] ) {
        [self setShowGood:[Check state]==NSOnState];
        [self.MoxConfigW setConfigDataWindow:[self.MoxConfig CopyConfig] ];
        [self.MoxConfigW StoreConfig];

    } else {
        [self setShowFavorites:[Check state]==NSOnState];
        [self.MoxConfigW setConfigDataWindow:[self.MoxConfig CopyConfig] ];
        [self.MoxConfigW StoreConfig];

    
    
    }

    
    [self ApplyFilters];
    if ( [ [self.FilterField stringValue] length ]==0 ) {
        [self.Tabla reloadData];

    } else {
        [self Change_filter:[self FilterField]];
    }
    
}

-(IBAction)GameSelected:(id)sender {
   
    NSTableView *v = (NSTableView *)sender;
  
    //NSLog(@"sc %lu",[v selectedRow]);
    if (![v isRowSelected:[v selectedRow]])
        return ;
    
    
    MoxGame *Game=[self.MoxGamesList objectAtIndex:[v selectedRow]];
    NSString * SnapGame=[[NSString alloc] initWithFormat:@"%@/%@/0000.png",[self.MoxConfig SnapPath],[Game Name] ];
    NSImage * Imagen=[[NSImage alloc] initWithContentsOfFile:SnapGame];
    
    
    if (Imagen==0) {
        Imagen=[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:@"noimage.png"]];
    }
    NSRect drawRect;
    NSSize imageSize = [Imagen size];
    NSSize NuevoSize=imageSize;

    NSLog(@"%f %f",imageSize.height,imageSize.width);

    
  
        float RatioX=self.ImageVIEW.bounds.size.width/imageSize.width;
        float RatioY= self.ImageVIEW.bounds.size.height/imageSize.height;
        NSSize SizeParent=self.ImageVIEW.bounds.size;
        NSLog(@"rx:%f ry:%f  ",RatioX,RatioY);
        
        if (RatioY>RatioX) {
            NuevoSize.width=imageSize.width*RatioX;
            NuevoSize.height=imageSize.height*RatioX;

        } else {
            NuevoSize.width=imageSize.width*RatioY;
            NuevoSize.height=imageSize.height*RatioY;

        }
    
    
    NSLog(@"Orig %f %f",imageSize.width,imageSize.height);

    NSLog(@"Post %f %f",NuevoSize.width,NuevoSize.height);
    
    NSImage * Cuadro=[[NSImage alloc] initWithSize:SizeParent  ];
    NSImage * Over=[[NSImage alloc] initWithSize:SizeParent];
    drawRect = NSMakeRect(0, 0, NuevoSize.width, NuevoSize.height);
    
    [Over lockFocus];
    [[NSColor blackColor] setFill];;
    [NSBezierPath fillRect:NSMakeRect(0, 0, SizeParent.width, SizeParent.height)];
    [Over unlockFocus];
    
    [Cuadro lockFocus];
     [Over drawInRect:NSMakeRect(0,0, SizeParent.width, SizeParent.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    [Imagen drawInRect:NSMakeRect(  (SizeParent.width-NuevoSize.width)/2  ,(SizeParent.height-NuevoSize.height)/2, NuevoSize.width, NuevoSize.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [Cuadro unlockFocus];
    
    CGImageRef cgImage = [Cuadro CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage] ;
    NSImage *finalImage = [[NSImage alloc] initWithSize:SizeParent] ;
    
    [finalImage addRepresentation:bitmapRep];
    NSRect RectaGradiente=NSMakeRect((SizeParent.width-NuevoSize.width)/2 ,((SizeParent.height-NuevoSize.height)/2) ,30,NuevoSize.height);
    
    NSGradient *Gradiente=[[NSGradient alloc] initWithStartingColor:[NSColor blackColor] endingColor:[[NSColor blackColor] colorWithAlphaComponent:0 ] ];
    [Cuadro lockFocus];
    [Gradiente drawInRect:RectaGradiente angle:0.0];
    [Gradiente drawInRect:NSMakeRect((SizeParent.width-NuevoSize.width)/2 ,  (((SizeParent.height-NuevoSize.height)/2)) +(NuevoSize.height)-30, NuevoSize.width, 30) angle:270]  ;
    [Gradiente drawInRect:NSMakeRect(NuevoSize.width+((SizeParent.width-NuevoSize.width)/2)-30, ((SizeParent.height-NuevoSize.height)/2)+30, 30, NuevoSize.height-30) angle:180];
    [Gradiente drawInRect:NSMakeRect((SizeParent.width-NuevoSize.width)/2 , ((SizeParent.height-NuevoSize.height)/2), NuevoSize.width, 30) angle:90];

    [Cuadro unlockFocus];
    
    [self.ImageVIEW setImage:Cuadro];
    //[self.ImageVIEW setima ]
    
    
}

-(void)double_click:(id)sender
{
    NSTableView *v = (NSTableView *)sender;
    if ([self.MoxGamesList count]<[v selectedRow] ) {
        return;
    }
    MoxGame *Game=[self.MoxGamesList objectAtIndex:[v selectedRow]];
    if ([self.MoxGamesList count]<[v selectedRow] ) {
        return;
    }
    [self RunGame:[Game Name]];

}

- (void) tableViewSelectionDidChange: (NSNotification *) notification
{
    long int row;
    row = [self.Tabla selectedRow];
    
    if (row == -1) {
        NSLog(@"NADASELECT");
            } else {
                [self GameSelected:[self Tabla]];
                    }
    
} // tableViewSelectionDidChange

-(void) RomFastAudit {
    NSError *Error;
    NSArray *_Dirlist=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self.MoxConfig RomPath] error:&Error ];
    NSMutableArray * Dirlist =[[NSMutableArray alloc]initWithArray:_Dirlist];
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
        ////NSLog(@"%lu %lu %lu",Gn,[Dirlist count],[self.MoxGameListNF count ]  );
       
        if (!(Fn < [Dirlist count])) {
            break;
        }
        _File=[Dirlist objectAtIndex:Fn];

     //   //NSLog(@"%@ %@",[NSString stringWithFormat:@"%@.zip",[_GAME Name] ] , _File);
        
       
        
        switch ([_File compare:[NSString stringWithFormat:@"%@.zip",[_GAME Name] ] ]) {
            case NSOrderedAscending:
               // //NSLog(@"mayor");
                Gn--;
                break;
            case NSOrderedSame:
               // //NSLog(@"IGUAL");
                [_GAME setEncontrado:YES];
                break;
            case NSOrderedDescending:
                ////NSLog(@"menor");
                [_GAME setEncontrado:NO];
                Fn--;
                

                break;
            default:
                break;
        }
        
    Fn++;
    }
    
    
    [self StoreGameList];
    [self ApplyFilters];
    
    if ([self ShowGood]) {
    
        if ( [ [self.FilterField stringValue] length ]==0 ) {
            [self.Tabla reloadData];
            
        } else {
            [self Change_filter:[self FilterField]];
        }
        
    }
    
    
    
}

-(void) StoreGameList {
    NSMutableDictionary * Storedict=[NSMutableDictionary dictionary];
    [Storedict setValue:[self MoxGameListNF] forKey:@"Lista"];

    [NSKeyedArchiver archiveRootObject:Storedict toFile:[[NSBundle mainBundle] pathForResource:@"gamelist" ofType:@"cfg" ]  ];
    

}
-(void)RunGame:(NSString *)Juego {
    NSMutableArray * Opciones=[[NSMutableArray alloc]init];

    [Opciones addObject:Juego];
    
    if ([self.MoxConfig keepAspect]) {
        [Opciones addObject:@"-ka"];
    } else {
        [Opciones addObject:@"-noka"];

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
    //NSLog(@"Run Game");
    [task launch];
    //NSLog(@"EndRungame");
    
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    //NSLog(@"%@",string);
    
    
    
}

-(void) ApplyFilters {
    [self.MoxGameListPreFilter removeAllObjects];
    [self.MoxGamesList removeAllObjects];
    NSArray *TmpArr;
    NSArray *TmpArr2;
    if ([self ShowFavorites]) {
        NSPredicate * FiltroGood=[NSPredicate predicateWithFormat:@"Favorito == YES"];
        TmpArr = [self.MoxGameListNF filteredArrayUsingPredicate:FiltroGood];
        //NSLog(@"Favoritos %lu", [TmpArr count]);
        
    }
    if ([self ShowGood]) {
        NSPredicate * Filtro=[NSPredicate predicateWithFormat:@"Encontrado == YES"];
        TmpArr2 = [[self ShowFavorites]?TmpArr:self.MoxGameListNF filteredArrayUsingPredicate:Filtro];
        
        //NSLog(@"Goods %lu", [TmpArr2 count]);

    }
    if ( ![self ShowGood] && ![self ShowFavorites]  ) {
        TmpArr = [self MoxGameListNF];
        //NSLog(@"todofalse");
    }
    //NSLog(@"FILTRANDO %u %u  ",[self ShowFavorites],[self ShowGood]);
    //NSLog(@"tmparr %lu",[TmpArr count]  );
    
    [self.MoxGameListPreFilter addObjectsFromArray:[self ShowGood]?TmpArr2:TmpArr];
    [self.MoxGamesList addObjectsFromArray:[self MoxGameListPreFilter]];
    //NSLog(@"%lu",[self.MoxGameListPreFilter count]);
    
}
-(IBAction)editFavorite:(id)sender
{ NSButton * Boton = (NSButton *) sender;
    
    if ([self.MoxGamesList count]<[self.Tabla selectedRow] ) {
        return;
    }
    MoxGame *Game;
    Game=[self.MoxGamesList objectAtIndex:[self.Tabla selectedRow]];

    if ([[Boton identifier] isEqualToString:@"add" ] ) {
        
        //en teoria este es el puntero al mismo objeto en MoxGameListNF;
        [Game setFavorito:YES];
        [self StoreGameList];
      
        
    } else {
        [Game setFavorito:NO];
        [self StoreGameList];

        if ([self ShowFavorites]) {
            //NSLog(@"RELOAD");
            [self ApplyFilters];
            [self.Tabla reloadData];
        }
        
    }
}


@end

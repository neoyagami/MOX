//
//  MoxGame.h
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoxGame : NSObject
@property(strong) NSString *Description;
@property(strong) NSString *Name;
@property(strong) NSString *Manufacturer;
@property(strong) NSString *Year;
@property(strong) NSString *Parent;


@property(assign) long  int GameId;
-(id) initWithTitle:(NSString*)Name Description:(NSString *)Description Manufacturer:(NSString *)Manufacturer Year:(NSString *)Year   GameId:(int) GameId Parent:(NSString*)Parent;


                                                        


@end

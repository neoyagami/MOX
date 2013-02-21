//
//  MoxGame.m
//  MOX
//
//  Created by Victor Lucero on 15-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import "MoxGame.h"

@implementation MoxGame

-(id) initWithTitle:(NSString*)Name Description:(NSString *)Description Manufacturer:(NSString *)Manufacturer Year:(NSString *)Year   GameId:(int) GameId  Parent:(NSString*)Parent {
  
    if ((self = [super init])) {
        
        [self setName:Name];
        [self setDescription:Description];
        [self setGameId:GameId];
        [self setManufacturer:Manufacturer];
        [self setYear:Year];
        [self setParent:Parent];
      /*  self.Name=Name;
        self.Description= Description;
        self.GameId=GameId;
        self.Manufacturer=Manufacturer;
        self.Year=Year;*/
        
        
     
        
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.Description forKey:@"Description"];
    [encoder encodeObject:self.Manufacturer forKey:@"Manufacturer"];
    [encoder encodeObject:self.Parent forKey:@"Parent"];
    [encoder encodeObject:self.Year forKey:@"Year"];

    [encoder encodeInteger:self.GameId forKey:@"GameId"];

}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        [self setName:[decoder decodeObjectForKey:@"Name"] ];
        [self setDescription:[decoder decodeObjectForKey:@"Description"] ];
        [self setManufacturer:[decoder decodeObjectForKey:@"Manufacturer"] ];
        [self setParent:[decoder decodeObjectForKey:@"Parent"] ];
        [self setYear:[decoder decodeObjectForKey:@"Year"] ];

        [self setGameId:[decoder decodeIntegerForKey:@"GameId"] ];

        
    }
    return self;
}




@end

//
//  MOXConfigData.m
//  MOX
//
//  Created by Victor Lucero on 18-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import "MOXConfigData.h"
@interface MOXConfigData() 
    
@end
@implementation MOXConfigData


-(id) initWithValues:(NSString *)MamePath GlobalPath:(NSString *)GlobalPath RomPath:(NSString *) RomPath SnapPath:(NSString *) SnapPath {
    if ((self = [super init])) {
        NSLog(@"%@ mamepath",MamePath);

        [self setMameBinPath:MamePath];
        [self setRomPath:RomPath];
        [self setGlobalDir:GlobalPath];
        [self setSnapPath:SnapPath];
        /*self.MameBinPath=MamePath;
        self.RomPath=RomPath;
        self.GlobalDir=GlobalPath;
        self.SnapPath=SnapPath;*/
        
    }
    
    
    return self;
}

-(id) CopyConfig {
    MOXConfigData * Copy=[[MOXConfigData alloc] initWithValues:self.MameBinPath GlobalPath:self.GlobalDir RomPath:self.RomPath SnapPath:self.SnapPath];
    [Copy setDelay:[self Delay]];
    [Copy setKeepAspect:[self keepAspect]];
    [Copy setSampleRate:[self SampleRate]];
    [Copy setFullScreen:[self FullScreen]];
    
    NSLog(@"%lu",[self SampleRate]);
    
    return Copy;
    
}



- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        [self setMameBinPath:[decoder decodeObjectForKey:@"MameBinPath"] ];
        [self setGlobalDir:[decoder decodeObjectForKey:@"GlobalDir"] ];
        [self setRomPath:[decoder decodeObjectForKey:@"RomPath"] ];
        [self setSnapPath:[decoder decodeObjectForKey:@"SnapPath"] ];

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.MameBinPath forKey:@"MameBinPath"];
    [encoder encodeObject:self.GlobalDir forKey:@"GlobalDir"];
    [encoder encodeObject:self.RomPath forKey:@"RomPath"];
    [encoder encodeObject:self.SnapPath forKey:@"SnapPath"];
}

-(void) CopyFromConfig:(MOXConfigData*)Config{
    [self setGlobalDir:[Config GlobalDir]];
    [self setRomPath:[Config RomPath]];
    [self setSnapPath:[Config SnapPath]  ];
    [self setMameBinPath:[Config MameBinPath]];
    [self setFullScreen:[Config FullScreen]];
    [self setKeepAspect:[Config keepAspect]];
    [self setSampleRate:[Config SampleRate]];
    [self setDelay:[Config Delay]];
}
    

@end


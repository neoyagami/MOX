//
//  MOXConfigData.h
//  MOX
//
//  Created by Victor Lucero on 18-02-13.
//  Copyright (c) 2013 Victor Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOXConfigData : NSObject <NSCoding>
@property (copy) NSString * RomPath;
@property (copy) NSString * MameBinPath;
@property (copy) NSString * GlobalDir;
@property (copy) NSString * SnapPath;
@property (assign) BOOL FullScreen;
@property (assign) long int SampleRate;
@property  (assign) BOOL keepAspect;
@property (assign) long int Delay;

-(id) CopyConfig;
-(id) initWithValues:(NSString *)MamePath GlobalPath:(NSString *)GlobalPath RomPath:(NSString *) RomPath SnapPath:(NSString *) SnapPath ;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
-(void) CopyFromConfig:(MOXConfigData*)Config;



@end

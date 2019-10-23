//
//  AnalysysAgentConfig.m
//  AnalysysAgent
//
//  Created by 向作为 on 2019/6/24.
//  Copyright © 2019 shaochong du. All rights reserved.
//

#import "AnalysysAgentConfig.h"

@implementation AnalysysAgentConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _channel = @"App Store";
        _autoProfile = YES;
        _autoInstallation = NO;
    }
    return self;
}

+ (instancetype)shareInstance {
    static AnalysysAgentConfig *instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[AnalysysAgentConfig alloc] init] ;
    });
    return instance;
}

@end


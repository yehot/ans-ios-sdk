//
//  ANSUserStrategy.h
//  AnalysysAgent
//
//  Created by SoDo on 2019/1/17.
//  Copyright © 2019 analysys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANSStrategyProtocol.h"

/**
 * @class
 * ANSUserStrategy
 *
 * @abstract
 * 用户策略
 *
 * @discussion
 * 存储用户自定义策略信息
 */

NS_ASSUME_NONNULL_BEGIN

@interface ANSUserStrategy : NSObject<NSCoding, ANSStrategyProtocol>

/**
 上传服务器地址
 */
@property (nonatomic, copy) NSString *serverUrl;

/**
 debug模式
 默认-1 无用户模式
 */
@property (nonatomic, assign) NSInteger debugMode;

/**
 上传间隔
 */
@property (nonatomic, assign) NSInteger flushInterval;

/**
 累积条数
 */
@property (nonatomic, assign) NSInteger flushBulkSize;


@end

NS_ASSUME_NONNULL_END

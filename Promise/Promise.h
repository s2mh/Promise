//
//  Promise.h
//  Promise
//
//  Created by yanweichen on 2019/1/30.
//  Copyright © 2019 s2mh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Promise<T> : NSObject

typedef void(^ResolveBlock)(T value);
typedef void(^RejectBlock)(id reason);
typedef void(^ExecutorBlock)(ResolveBlock, RejectBlock);

typedef void(^OnFulfilledBlock)(T value);
typedef void(^OnRejectedBlock)(id reaseon);

+ (Promise<T> *(^)(ExecutorBlock))promise;
- (Promise<T> *(^)(OnFulfilledBlock _Nullable, OnRejectedBlock _Nullable))then;
- (Promise<T> *(^)(OnRejectedBlock _Nullable))catch;

@end

NS_ASSUME_NONNULL_END

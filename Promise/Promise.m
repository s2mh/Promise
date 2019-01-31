//
//  Promise.m
//  Promise
//
//  Created by yanweichen on 2019/1/30.
//  Copyright © 2019 s2mh. All rights reserved.
//

#import "Promise.h"

typedef id T;

@interface Promise ()

@property (nonatomic, assign) BOOL done;
@property (nonatomic, copy) NSMutableArray<OnFulfilledBlock> *onFulfilleds;
@property (nonatomic, copy) NSMutableArray<OnRejectedBlock> *onRejecteds;

@end

@implementation Promise

+ (Promise<T> * _Nonnull (^)(ExecutorBlock _Nonnull))promise
{
    return ^Promise *(ExecutorBlock executorBlock) {
        Promise *promise = [Promise new];
        [promise performSelector:@selector(callExecutorBlcok:)
                        onThread:[NSThread currentThread]
                      withObject:executorBlock
                   waitUntilDone:NO];
        return promise;
    };
}

- (Promise<T> * _Nonnull (^)(OnFulfilledBlock _Nullable, OnRejectedBlock _Nullable))then
{
    return ^Promise *(OnFulfilledBlock onFulfilled, OnRejectedBlock onRejected) {
        if (onFulfilled) {
            [self.onFulfilleds addObject:onFulfilled];
        }
        if (onRejected) {
            [self.onRejecteds addObject:onRejected];
        }
        return self;
    };
}

- (Promise<T> * _Nonnull (^)(OnRejectedBlock _Nullable))catch
{
    return ^Promise *(OnRejectedBlock onRejected) {
        if (onRejected) {
            [self.onRejecteds addObject:onRejected];
        }
        return self;
    };
}

- (void)callExecutorBlcok:(ExecutorBlock)block
{
    if (block) {
        ResolveBlock resolve = ^(T value){
            if (self.done) {
                return;
            }
            [self.onFulfilleds enumerateObjectsUsingBlock:^(OnFulfilledBlock  _Nonnull onFulfilled, NSUInteger idx, BOOL * _Nonnull stop) {
                onFulfilled(value);
            }];
            self.done = YES;
        };
        RejectBlock reject = ^(id reason){
            if (self.done) {
                return;
            }
            [self.onRejecteds enumerateObjectsUsingBlock:^(OnFulfilledBlock  _Nonnull onRejected, NSUInteger idx, BOOL * _Nonnull stop) {
                onRejected(reason);
            }];
            self.done = YES;
        };
        block(resolve, reject);
    }
}

- (NSMutableArray<OnFulfilledBlock> *)onFulfilleds
{
    if (!_onFulfilleds) {
        _onFulfilleds = [NSMutableArray arrayWithCapacity:1];
    }
    return _onFulfilleds;
}

- (NSMutableArray<OnRejectedBlock> *)onRejecteds
{
    if (!_onRejecteds) {
        _onRejecteds = [NSMutableArray arrayWithCapacity:1];
    }
    return _onRejecteds;
}

@end

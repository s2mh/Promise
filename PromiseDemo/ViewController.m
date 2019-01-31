//
//  ViewController.m
//  Promise
//
//  Created by yanweichen on 2019/1/31.
//  Copyright © 2019 s2mh. All rights reserved.
//

#import "ViewController.h"
#import "Promise.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (NSInteger i = 10; i > 0; i--) {
        [self testPromise];
    }
}

- (void)testPromise
{
    Promise<NSNumber *> *promise = Promise.promise(^(ResolveBlock resolve, RejectBlock reject){
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
            uint32_t random = arc4random();
            (random % 2) ? resolve(@(random)) : reject(@(random));
        }];
    }).then(^(NSNumber *value){
        NSLog(@"value  : %@", value);
    }, NULL).catch(^(id reason){
        NSLog(@"reject : %@", reason);
    });
    
    promise.then(^(NSNumber *value){
        NSLog(@"+++++++++++++++++++++");
    }, ^(id reason){
        NSLog(@"---------------------");
    });
}

@end

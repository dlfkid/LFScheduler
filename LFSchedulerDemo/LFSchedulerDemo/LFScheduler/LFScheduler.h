//
//  MidDispatcher.h
//  TCLSmartHome
//
//  Created by LeonDeng on 2019/5/25.
//  Copyright © 2019 TCLIOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^LFSchedulerCompletion)(NSDictionary * _Nullable params);
typedef void(^LFSchedulerNoProviderHandler) (NSString * _Nonnull providerName, NSString * _Nonnull actionName, NSDictionary * _Nullable params);

NS_ASSUME_NONNULL_BEGIN

@interface LFScheduler : NSObject

/**
 This is the handler block called when schedule can't find provider
 */
@property (nonatomic, copy) LFSchedulerNoProviderHandler noProviderHandler;

/**
 This is the method name when your provider can't find sepcific action, it will invoke this method, if not setted, scheduler will call no provider handler above.
 */
@property (nonatomic, copy, nullable) NSString *providerDefaultActionName;

+ (instancetype)sharedScheduler;

/**
 Api for remote invoke

 @param url invoke from outside
 @param completion callback block when invoke is finished
 @return value to return
 */
- (id)invokeWithURL:(NSURL *)url Completion:(LFSchedulerCompletion _Nullable )completion;

/**
 Api for loacl invoke

 @param providerName Provider class string
 @param actionName Method name for invoke
 @param params parameters
 @param shouldCacheProvider choose to cache the provider instance or not
 @return value to return
 */
- (id)invokeWithProviderClass:(NSString * _Nonnull)providerName
                  Action:(NSString * _Nonnull)actionName
                  Params:(NSDictionary * _Nullable)params
             CacheProvider:(BOOL)shouldCacheProvider;


/**
 release cached provider instance

 @param providerName provider class string
 */
- (void)releaseCachedProviderClass:(NSString *)providerName;

@end

NS_ASSUME_NONNULL_END

//
//  MidDispatcher.m
//  TCLSmartHome
//
//  Created by LeonDeng on 2019/5/25.
//  Copyright © 2019 TCLIOT. All rights reserved.
//

#import "LFScheduler.h"

@interface LFScheduler()

@property (nonatomic, strong) NSMutableDictionary *cachedProviders;

@end

static LFScheduler *_sharedMidDispatcher = nil;

@implementation LFScheduler

#pragma mark - Public

+ (instancetype)sharedScheduler {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMidDispatcher = [[LFScheduler alloc] init];
    });
    return _sharedMidDispatcher;
}

- (id)invokeWithProviderClass:(NSString *)providerName Action:(NSString *)actionName Params:(NSDictionary *)params CacheProvider:(BOOL)shouldCacheTarget {
    // generate target
    NSString *providerClassString = [NSString stringWithFormat:@"%@", providerName];
    NSObject *targetProvider = self.cachedProviders[providerClassString];
    if (targetProvider == nil) {
        Class targetClass = NSClassFromString(providerClassString);
        targetProvider = [[targetClass alloc] init];
    }
    
    // generate action
    NSString *actionString = [NSString stringWithFormat:@"%@:", actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (targetProvider == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithProviderName:providerClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedProviders[providerClassString] = targetProvider;
    }
    
    if ([targetProvider respondsToSelector:action]) {
        return [self safePerformAction:action Provider:targetProvider params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(self.providerDefaultActionName);
        if ([targetProvider respondsToSelector:action]) {
            
            return [self safePerformAction:action Provider:targetProvider params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithProviderName:providerClassString selectorString:actionString originParams:params];
            [self.cachedProviders removeObjectForKey:providerClassString];
            return nil;
        }
    }
}

- (id)invokeWithURL:(NSURL *)url Completion:(LFSchedulerCompletion)completion {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
//    if (![actionName hasPrefix:@"remote"]) {
//        return @(NO);
//    }
    
    id result = [self invokeWithProviderClass:url.host Action:actionName Params:params CacheProvider:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (void)releaseCachedProviderClass:(NSString *)providerName {
    NSString *providerClassString = [NSString stringWithFormat:@"%@", providerName];
    [self.cachedProviders removeObjectForKey:providerClassString];
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithProviderName:(NSString *)providerName selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams {
    NSLog(@"LFScheduler ERROR : No provider class found, Provider: %@, Action: %@, Parameters: %@", providerName, selectorString, originParams.description);
    !self.noProviderHandler ?: self.noProviderHandler(providerName, selectorString, originParams);
}

- (id)safePerformAction:(SEL)action Provider:(NSObject *)provider params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [provider methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:provider];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:provider];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:provider];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:provider];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:provider];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [provider performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - LazyLoads
- (NSMutableDictionary *)cachedProviders {
    if (_cachedProviders == nil) {
        _cachedProviders = [[NSMutableDictionary alloc] init];
    }
    return _cachedProviders;
}

@end

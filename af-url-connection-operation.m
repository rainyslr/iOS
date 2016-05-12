static NSString * const kAFNetworkingLockName = @"com.alamofire.networking.operation.lock";
// 这个字符串干嘛用的？？

typedef NS_ENUM(NSInteger, AFOperationState) {
    AFOperationPausedState      = -1,
    AFOperationReadyState       = 1,
    AFOperationExecutingState   = 2,
    AFOperationFinishedState    = 3,
};

// 状态的改变：finish之后变为AFOperationFinishedState


- (void)setCompletionBlock:(void (^)(void))block {
    if (!block) {
        [super setCompletionBlock:nil];
    } else {
        __weak __typeof(self)weakSelf = self;
        [super setCompletionBlock:^ {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            // strongSelf.completionGroup和completionQueue什么时候会改变
            dispatch_group_t group = strongSelf.completionGroup ?: url_request_operation_completion_group();
            dispatch_queue_t queue = strongSelf.completionQueue ?: dispatch_get_main_queue();

            dispatch_group_async(group, queue, ^{
                block();
            });

            // 为什么还要再set一次呢？完全不懂这段话的功能，添加一个空的代码块？？
            dispatch_group_notify(group, queue, ^{
                [strongSelf setCompletionBlock:nil];
            });
        }];
    }
    [self.lock unlock];
}

- (void)finish {
    self.state = AFOperationFinishedState; 
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingOperationDidFinishNotification object:self];
    });
}

- (void)connection:(NSURLConnection __unused *)connection
  didFailWithError:(NSError *)error
{
    self.error = error; 
    [self.outputStream close];   
    [self finish];  
    self.connection = nil;
}

- (void)cancelConnection {
NSDictionary *userInfo = nil;
    if ([self.request URL]) {
        userInfo = [NSDictionary dictionaryWithObject:[self.request URL] forKey:NSURLErrorFailingURLErrorKey];
    }
    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];

    if (![self isFinished] && self.connection) {
        [self.connection cancel];
        [self performSelector:@selector(connection:didFailWithError:) withObject:self.connection withObject:error];
    }
}

- (void)cancel {
    if (![self isFinished] && ![self isCancelled]) {
        [self willChangeValueForKey:@"isCancelled"];
        self.cancelled = YES;
        [super cancel];
        [self didChangeValueForKey:@"isCancelled"];
        // Cancel the connection on the thread it runs on to prevent race conditions
        [self performSelector:@selector(cancelConnection) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
}

// returns `NO` for `-isReady`, `-isExecuting`, and `-isFinished`
// pause函数什么时候会被运行。
// it will remain in an `NSOperationQueue` until it is either cancelled or resumed.
// pause在(![self isFinished] && self.connection)会调用void)connection:(NSURLConnection __unused *)connection
// didFailWithError:(NSError *)error
// 这个函数中会调用finish函数，发送AFNetworkingOperationDidFinishNotification通知并把状态设置为AFOperationFinishedState
// 如此岂不是与pause函数中发送了AFNetworkingOperationDidFinishNotification通知并把状态设置为 AFOperationPausedState重复？？
- (void)pause {
    // Pausing a finished, cancelled, or paused operation has no effect.
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }
    
    [self.lock lock];
    
    if ([self isExecuting]) {
        // networkRequestThread：类函数，获取"AFNetworking"线程
        
        [self.connection performSelector:@selector(cancel) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:AFNetworkingOperationDidFinishNotification object:self];
        });
    }   
    self.state = AFOperationPausedState;  
    [self.lock unlock];
}


//！！！！！ 这个函数都看不太懂
- (void)setShouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler {
    [self.lock lock];
    if (!self.backgroundTaskIdentifier) {
        UIApplication *application = [UIApplication sharedApplication];
        __weak __typeof(self)weakSelf = self;
        self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (handler) {
                handler();
            }
           
            if (strongSelf) {
            	 // 为什么要cancel呢？？
                [strongSelf cancel];  
                [application endBackgroundTask:strongSelf.backgroundTaskIdentifier];
                strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            }
        }];
    }
    [self.lock unlock];
}


- (void)operationDidStart {
    [self.lock lock];
    if (! [self isCancelled]) {
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        for (NSString *runLoopMode in self.runLoopModes) {
            [self.connection scheduleInRunLoop:runLoop forMode:runLoopMode];
            [self.outputStream scheduleInRunLoop:runLoop forMode:runLoopMode];
        }
        // 这个函数有机会看看
        [self.connection start];
    }
    [self.lock unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingOperationDidStartNotification object:self];
    });
    
    if ([self isCancelled]) {
    	// 如果被取消，就结束线程？真是不知道这个条件什么时候会出现
        [self finish];
    }
}

- (void)connection:(NSURLConnection __unused *)connection
didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    
    [self.outputStream open];
}




(NSArray *)batchOfRequestOperations:(NSArray *)operations
                        progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                      completionBlock:(void (^)(NSArray *operations))completionBlock
{

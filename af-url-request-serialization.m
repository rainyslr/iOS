parameter或者是Get报文中的query string或者作为报文的body。这个query string是什么意思呢
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error
{
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = method;

    for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
    	// AFHTTPRequestSerializerObservedKeyPaths()返回一个集合：allowsCellularAccess，cachePolicy，HTTPShouldHandleCookies，HTTPShouldUsePipelining，networkServiceType，timeoutInterval
    	// 将mutableObservedChangedKeyPaths中包含上述集合中的keypath值在mutableRequest中做相应设置
        if ([self.mutableObservedChangedKeyPaths containsObject:keyPath]) {
            [mutableRequest setValue:[self valueForKeyPath:keyPath] forKey:keyPath];
        }
    }

    mutableRequest = [[self requestBySerializingRequest:mutableRequest withParameters:parameters error:error] mutableCopy];
	return mutableRequest;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);

    1.NSMutableURLRequest *mutableRequest = [request mutableCopy];
    2.根据self.HTTPRequestHeaders设置mutableRequest头部
    
    if (parameters) 
    {
        NSString *query = nil;
        if (self.queryStringSerialization)//序列化query的代码块不空
            query = self.queryStringSerialization(request, parameters, &serializationError);

        else 
        {
        	if(self.queryStringSerializationStyle == AFHTTPRequestQueryStringDefaultStyle)
                query = AFQueryStringFromParametersWithEncoding(parameters, self.stringEncoding);
        }
        if(当前request中的方法是AFURLRequestSerialization允许的方法)
        {
        	if(mutableRequest.URL中已经有查询组件)
        		mutableRequest.URL += query;
        	else
        		mutableRequest.URL += '?' + query
        }
        else [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
    }
    return mutableRequest;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    return [self multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:nil];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *mutableRequest = [self requestWithMethod:method URLString:URLString parameters:nil error:error];
    __block AFStreamingMultipartFormData *formData = [[AFStreamingMultipartFormData alloc] initWithURLRequest:mutableRequest stringEncoding:NSUTF8StringEncoding];
    if (parameters) {
        for (AFQueryStringPair *pair in AFQueryStringPairsFromDictionary(parameters)) {
            NSData *data = nil;
            if ([pair.value isKindOfClass:[NSData class]]) {
                data = pair.value;
            } else if ([pair.value isEqual:[NSNull null]]) {
                data = [NSData data];
            } else {
                data = [[pair.value description] dataUsingEncoding:self.stringEncoding];
            }
            if (data) {
                [formData appendPartWithFormData:data name:[pair.field description]];
            }
        }
    }
    if (block) {
        block(formData);
    }
    return [formData requestByFinalizingMultipartFormData];
}

- (NSMutableURLRequest *)requestWithMultipartFormRequest:(NSURLRequest *)request
                             writingStreamContentsToFile:(NSURL *)fileURL
                                       completionHandler:(void (^)(NSError *error))handler
{
	1.在全局并发队列中同步提交任务（等该任务执行结束才返回）
	2.任务内容：
		（1）request.HTTPBodyStream中的内容写到fileURL对应的文件
		（2）
		 if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error);
            });
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.HTTPBodyStream = nil;
    // 看不懂，为啥要将HTTPBodyStream置为空，这个函数的意义何在
    return mutableRequest;
}
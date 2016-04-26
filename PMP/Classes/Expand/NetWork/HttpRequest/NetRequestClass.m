//
//  NetRequestClass.m
//  建信
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 yuantu. All rights reserved.
//

#import "NetRequestClass.h"
#import <AFNetworking.h>
#import "AccountModel.h"
 #import <CommonCrypto/CommonDigest.h>
@implementation NetRequestClass

#pragma 监测网络的可链接性
+ (BOOL)netWorkReachabilityWithURLString:(NSString *)strUrl{
    
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState=YES;
                break;
           case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}

#pragma --mark GET请求方式
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    AccountModel *account =[AccountModel shareAccount];
    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
    
    [manager.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];

    
    long long dateNum = [NetRequestClass longLongFromDate:[NSDate date]];
    NSString *sha1str=[NSString stringWithFormat:@"%@%lld",account.credential,dateNum];
    sha1str =  [NetRequestClass sha1:sha1str];
    [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
    
    manager.responseSerializer  =[AFHTTPResponseSerializer serializer];
    
    [manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *obj =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
  
        if ([dic[@"status"] intValue]!=200) {
          
            if ( errorBlock) {
                errorBlock(dic);
            }

        }else{
            if(block){
                block(dic);
            }
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failureBlock();
        
    }];
    
    
}

#pragma --mark POST请求方式

+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    AccountModel *account =[AccountModel shareAccount];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
  
    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
    [manager.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
 
    long long dateNum = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *sha1str=[NSString stringWithFormat:@"%@%lld",account.credential,dateNum];
    sha1str =  [NetRequestClass sha1:sha1str];
    [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *obj =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        if (operation.response.allHeaderFields[@"credential"]) {
             account.credential =operation.response.allHeaderFields[@"credential"];
        }
        if (operation.response.allHeaderFields[@"token"]) {
             account.token      =operation.response.allHeaderFields[@"token"];
        }
       
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        
        if ([dic[@"status"] intValue]!=200) {
            
            if ( errorBlock) {
                errorBlock(dic);
            }

         
        }else{
            if(block){
                block(dic);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failureBlock();
    }];

    
}


+ (void) NetJsonRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    AccountModel *account =[AccountModel shareAccount];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
     [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
    [manager.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
    
    long long dateNum = [NetRequestClass longLongFromDate:[NSDate date]];
    NSString *sha1str=[NSString stringWithFormat:@"%@%lld",account.credential,dateNum];
    sha1str =  [NetRequestClass sha1:sha1str];
    [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *obj =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",obj);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([dic[@"status"] intValue]!=200) {
            
            if ( errorBlock) {
                errorBlock(dic);
            }

        }else{
            if(block){
                block(dic);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failureBlock();
    }];
    
}


+ (NSString *)sha1:(NSString *)inputStr {
    
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}

+(long long)longLongFromDate:(NSDate*)date{
    return [date timeIntervalSince1970] * 1000;
}

+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    //沙盒路径    //NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xxx.zip"];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    //以下是手动创建request方法 AFQueryStringFromParametersWithEncoding有时候会保存
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    //   NSMutableURLRequest *request =[[[AFHTTPRequestOperationManager manager]requestSerializer]requestWithMethod:@"POST" URLString:requestURL parameters:paramaterDic error:nil];
    //
    //    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //
    //    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(paramaterDic, NSASCIIStringEncoding) dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}


@end

//
//  HttpRequestManager.m
//  LotteryServer
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Macczz. All rights reserved.
//

#import "HttpRequestManager.h"
#import "AFNetworking.h"
//#import <XMLDictionary/XMLDictionary.h>

@implementation HttpRequestManager

+ (void)getJsonRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *utf8String = [HttpRequestManager revertURLStringWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    [manager GET:utf8String parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }else{
            dataDic = responseObject;
        }
        if (success && dataDic) {
            NSLog(@"%@",[self exportStringWithObject:dataDic urlString:urlString isSuccess:YES]);
            success(dataDic);
        }else{
            NSString *errorMessage = @"数据格式错误";
            NSError *error = [NSError errorWithDomain:@"com.czz.error" code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            NSLog(@"%@",[self exportStringWithObject:errorMessage urlString:urlString isSuccess:NO]);
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"%@",[self exportStringWithObject:error.localizedDescription urlString:urlString isSuccess:NO]);
            failure(error);
        }
    }];
}

//+ (void)getXmlRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure{
//     NSString *utf8String = [HttpRequestManager revertURLStringWithString:urlString];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
//    [manager GET:utf8String parameters:paramaters progress:^(NSProgress * _Nonnull downloadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dataDic = nil;
//        
//        if ([responseObject isKindOfClass:[NSData class]]) {
//            dataDic = [NSDictionary dictionaryWithXMLData:responseObject];
//            NSLog(@"%@",dataDic);
//        }else{
//            dataDic = responseObject;
//        }
//        if (success && dataDic) {
//            NSLog(@"%@",[self exportStringWithObject:dataDic urlString:urlString isSuccess:YES]);
//            success(dataDic);
//        }else{
//            NSString *errorMessage = responseObject[@"msg"] ? responseObject[@"msg"] : @"数据格式错误";
//            NSError *error = [NSError errorWithDomain:@"com.czz.error" code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
//            NSLog(@"%@",[self exportStringWithObject:errorMessage urlString:urlString isSuccess:NO]);
//            failure(error);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failure) {
//            NSLog(@"%@",[self exportStringWithObject:error.localizedDescription urlString:urlString isSuccess:NO]);
//            failure(error);
//        }
//    }];
//}

+ (void)postJsonRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *utf8String = [HttpRequestManager revertURLStringWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:utf8String parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }else{
            dataDic = responseObject;
        }
        if (success && dataDic) {
            NSLog(@"parameters ==>%@",paramaters);
            NSLog(@"%@",[self exportStringWithObject:dataDic urlString:urlString isSuccess:YES]);
            success(dataDic);
        }else{
            NSString *errorMessage = @"数据格式错误";
            NSError *error = [NSError errorWithDomain:@"com.czz.error" code:0 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            NSLog(@"%@",[self exportStringWithObject:errorMessage urlString:urlString isSuccess:NO]);
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSLog(@"%@",[self exportStringWithObject:error.localizedDescription urlString:urlString isSuccess:NO]);
            failure(error);
        }
    }];
}

+ (NSString *)revertURLStringWithString:(NSString *)urlString {
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *utf8String = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return utf8String;
}


+ (NSString *)stitchingParameters:(NSDictionary *)infoDic {
    NSMutableString *stitchingString = [NSMutableString string];
    for (NSString *key in [infoDic allKeys]) {
        NSString *value = [NSString stringWithFormat:@"%@",infoDic[key]];
        [stitchingString appendString:key];
        [stitchingString appendString:@"="];
        [stitchingString appendString:value];
        [stitchingString appendString:@"&"];
    }
    [stitchingString deleteCharactersInRange:NSMakeRange(stitchingString.length - 1, 1)];
    
    
    return stitchingString;
}

+ (NSString *)exportStringWithObject:(id)object urlString:(NSString *)urlString isSuccess:(BOOL)isSuccess{
    NSString *objectString = [NSString stringWithFormat:@"%@",object];
    NSString *conversionString = [self replaceUnicode:objectString];
    NSString *exportString = nil;
    if (isSuccess) {
        exportString = [NSString stringWithFormat:@"====== success ======\n url = %@ \n response = %@",urlString,conversionString];
    }else{
            exportString = [NSString stringWithFormat:@"====== fail ======\n url = %@ \n response = %@",urlString,conversionString];
    }
    return exportString;
}


+ (NSString*) replaceUnicode:(NSString*)TransformUnicodeString

{
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString*tepStr3 = [[@"\"" stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    
    NSData*tepData = [tepStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListImmutable format:nil error:NULL];
    
    return [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}


@end

//
//  HttpRequestManager.h
//  LotteryServer
//
//  Created by Mac on 2017/7/11.
//  Copyright © 2017年 Macczz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestManager : NSObject

+ (void)getJsonRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//+ (void)getXmlRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)postJsonRequestWithUrl:(NSString *)urlString parameters:(NSDictionary *)paramaters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (NSString *)stitchingParameters:(NSDictionary *)infoDic;

@end

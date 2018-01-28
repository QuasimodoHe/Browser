//
//  HomeCollectionModel.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCollectionModel : NSObject
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *targetUrl;
@property (nonatomic,assign) BOOL isHomeUrl;
@end

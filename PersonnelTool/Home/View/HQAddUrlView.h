//
//  HQAddUrlView.h
//  PersonnelTool
//
//  Created by  Quan He on 2018/1/22.
//  Copyright © 2018年 gd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HQAddUrlViewDelegate <NSObject>
- (void)addUrlViewCancelAction;
- (void)addUrlViewSureAction;
@end
@interface HQAddUrlView : UIView
@property (nonatomic, weak) id <HQAddUrlViewDelegate>delegate;
- (void)showKeyBoard;
- (void)hideAction;
@property (strong, nonatomic) IBOutlet UITextField *urlTextFiled;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (assign, nonatomic) BOOL isChange;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) HomeCollectionModel *model;
@end

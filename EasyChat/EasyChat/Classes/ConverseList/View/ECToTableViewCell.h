//
//  ECToTableViewCell.h
//  EasyChat
//
//  Created by wanghu on 16/5/9.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMSDK.h"

@interface ECToTableViewCell : UITableViewCell
@property (nonatomic, strong) EMMessage *message;
@end

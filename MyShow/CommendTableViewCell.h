//
//  CommendTableViewCell.h
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@interface CommendTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *headImageView;
@property (strong, nonatomic)  UIButton    *locationBtn;
@property (strong, nonatomic)  UILabel     *nameLabel;
//@property (strong, nonatomic)  UIImageView *startView;
@property (strong, nonatomic)  UILabel     *numLabel;
@property (strong, nonatomic)  UIImageView *bigPicView;

-(void)configWithModel:(CommentModel *)model;

@end

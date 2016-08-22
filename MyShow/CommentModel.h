//
//  CommentModel.h
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic, assign  ) NSInteger   allnum;

//房间id
@property (nonatomic, copy  ) NSString   *roomid;
//服务器id
@property (nonatomic, copy  ) NSString   *serverid;

//所在地
@property (nonatomic, copy  ) NSString   *gps;

//直播流
@property (nonatomic, copy  ) NSString   *flv;

@property (nonatomic, copy  ) NSString   *starlevel;

//
@property (nonatomic, copy  ) NSString   *useridx;

//主播id
@property (nonatomic, copy  ) NSString   *userId;


@property (nonatomic, copy  ) NSString   *gender;

//昵称
@property (nonatomic, copy  ) NSString   *myname;

//个性签名
@property (nonatomic, copy  ) NSString   *signatures;

//小图 主播头像
@property (nonatomic, copy  ) NSString   *smallpic;

//大图
@property (nonatomic, copy  ) NSString   *bigpic;


@property (nonatomic, copy  ) NSString   *level;

@property (nonatomic, copy  ) NSString   *grade;

@property (nonatomic, copy  ) NSString   *curexp;



@end

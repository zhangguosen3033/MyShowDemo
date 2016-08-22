//
//  CommendLiveViewController.m
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "CommendLiveViewController.h"
#import "CommendTableViewCell.h"
#import "CommentModel.h"
#import "PlayerViewController.h"
@interface CommendLiveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray  *_TableViewdataArray;
    
    NSInteger _offset;
  
    BOOL _isPulling;

    
}

@property (nonatomic, strong) BAURLSessionTask  *tasks;

@end

@implementation CommendLiveViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden =YES;
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _TableViewdataArray =[[NSMutableArray alloc]init];
    
    _offset = 1;

    [self CreatUI];
    
    [self CreatData];
    
    [self CreatRefresh];
    
    
}

-(void)CreatRefresh{
   
    _tableView.mj_header = [GSRefreshGifHeader headerWithRefreshingBlock:^{
        
        _offset = 1;
        
        [self CreatData];
        
    }];
    
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _offset++;
        
        [self CreatData];

    }];
    
    

}

-(void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}


-(void)CreatUI{
    
   _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
      //设置滚动边框隐藏
    _tableView.showsVerticalScrollIndicator =
    NO;
    
//    //用来解决下属的子视图进入导航栏内部的问题
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.modalPresentationCapturesStatusBarAppearance = NO;
//    
//    [self.view bringSubviewToFront:_tableView];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _TableViewdataArray.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 360;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell = [[CommendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    
    CommentModel *model = _TableViewdataArray[indexPath.row];
    
    [cell configWithModel:model];
    
    
    return cell ;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     CommentModel *model = _TableViewdataArray[indexPath.row];
    
    PlayerViewController *player = [[PlayerViewController alloc] init];
    
    player.playurl = model.flv;
    
    player.imageUrl = model.bigpic;
    
    player.lives = _TableViewdataArray;
    
    player.currentIndex = indexPath.row-1;
    
    [self presentViewController:player animated:YES completion:nil];
    
    
    
}


-(void)CreatData{
    
    self.tasks = [BANetManager ba_requestWithType:BAHttpRequestTypeGet withUrlString:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld",_offset ] withParameters:nil withSuccessBlock:^(id response) {
        
        [self endRefresh];
        
        /*! 新增get请求缓存，飞行模式下开启试试看！ */
//        NSLog(@"get请求数据成功： *** %@", response);
        if (response&&([[response objectForKey:@"code"] integerValue]==100)) {
            
            NSDictionary *datadic =[response objectForKey:@"data"];
            
            NSArray *array = [datadic objectForKey:@"list"];
            
            for (NSDictionary *dic in array) {
                
                CommentModel *model = [[CommentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_TableViewdataArray addObject:model];
            }
            
            [_tableView reloadData];
            
 
        }
        return;
    } withFailureBlock:^(NSError *error) {
        
        [self endRefresh];
        
    } progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

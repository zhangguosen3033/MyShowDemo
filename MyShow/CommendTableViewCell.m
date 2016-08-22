//
//  CommendTableViewCell.m
//  MyShow
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 张国森. All rights reserved.
//

#import "CommendTableViewCell.h"

@implementation CommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
    }
    
    return self;
}


-(void)createUI{
    
    self.headImageView =[[UIImageView alloc]init];
    
    [self.contentView addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).offset(10);
        
        make.top.mas_equalTo(self.contentView).offset(5);
        
        make.width.mas_equalTo(@50);
        
        make.height.mas_equalTo(@50);
        
        
    }];
    
    
    self.nameLabel =[[UILabel alloc]init];
    
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.headImageView.mas_right).offset(5);
        
        make.top.mas_equalTo(self.contentView).offset(5);
        
        make.width.mas_equalTo(@200);
        
        make.height.mas_equalTo(@20);
        
        
    }];

    
    self.numLabel =[[UILabel alloc]init];
    
    self.numLabel.textAlignment = UITextAlignmentRight;

    [self.contentView addSubview:self.numLabel];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.contentView).offset(-10);
        
        make.top.mas_equalTo(self.contentView).offset(10);
        
        make.width.mas_equalTo(@150);
        
        make.height.mas_equalTo(@30);
        
        
    }];

    self.bigPicView =[[UIImageView alloc]init];
    
    [self.contentView addSubview:self.bigPicView];
    
    [self.bigPicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).offset(0);
        
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(5);
        
        make.right.mas_equalTo(self.contentView).offset(0);
        
        make.height.mas_equalTo(@300);
        
        
    }];
    

    self.locationBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.contentView addSubview:self.locationBtn];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.headImageView.mas_right).offset(5);
        
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        
        make.width.mas_equalTo(@50);
        
        make.height.mas_equalTo(@20);
        
        
    }];

    
}

-(void)configWithModel:(CommentModel *)model
{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        image = [UIImage  circleImage:image borderColor:[UIColor redColor] borderWidth:1];
        self.headImageView.image = image;
    }];
    
    self.nameLabel.text = model.myname;
    // 如果没有地址, 给个默认的地址
    if (!model.gps.length) {
        model.gps = @"喵星";
    }
    [self.locationBtn setTitle:model.gps forState:UIControlStateNormal];
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:model.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
//    self.startView.image  = live.starImage;
//    self.startView.hidden = !live.starlevel;
    
    // 设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%ld人在看", model.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld", model.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
//    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.numLabel.attributedText = attr;
  
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

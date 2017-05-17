//
//  DisplayADView.m
//  自定义启动图广告
//
//  Created by haozp on 2017/5/17.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "DisplayADView.h"

@interface DisplayADView ()
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int leftTime;
@property (nonatomic, strong) UIButton *skipButton;
@end

@implementation DisplayADView

- (instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        NSLog(@"=%@",infoDict);
        
        //拿到启动图数组
        NSArray *launchImages = [infoDict objectForKey:@"UILaunchImages"];
        
        for (NSDictionary *imageDict in launchImages) {
            
            NSString *imageSizeStr = [imageDict objectForKey:@"UILaunchImageSize"];
            CGSize imageSize = CGSizeFromString(imageSizeStr);
            
            if (CGSizeEqualToSize(imageSize, [UIScreen mainScreen].bounds.size)) {
                NSString *imageName = [imageDict objectForKey:@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:imageName];
                
                UIColor *bgcolor = [UIColor colorWithPatternImage:image];
                self.backgroundColor = bgcolor;
                
//                self.backgroundColor = [UIColor redColor];
            }
        }
        
       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 5*CGRectGetHeight(self.bounds)/6.0)];
        imageView.image = image;
        [self addSubview:imageView];
        
        //添加一个点击手势，点击跳广告详情页面
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRAction)];
        [imageView addGestureRecognizer:tapGR];
        imageView.userInteractionEnabled = YES;
        
        //倒计时
        _leftTime = 10;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        //按钮
        CGFloat buttonWidth = 50;
        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-80, 60, buttonWidth, buttonWidth)];
        self.skipButton = skipButton;
        skipButton.layer.cornerRadius = buttonWidth/2.0;
        skipButton.layer.masksToBounds = YES;
        skipButton.backgroundColor = [UIColor yellowColor];
        skipButton.titleLabel.numberOfLines = 2;
        skipButton.titleLabel.textAlignment = 1;
        [skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [skipButton setTitle:@"10s\n跳过" forState:UIControlStateNormal];
        skipButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:skipButton];
        
        
        //倒计时动画***
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //画个圆
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(buttonWidth/2, buttonWidth/2) radius:buttonWidth/2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 4;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor lightGrayColor].CGColor;
        
        //线路动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        animation.fromValue = @0;
        animation.toValue = @1;
        animation.duration = _leftTime;
        
        [shapeLayer addAnimation:animation forKey:nil];
        
        
        [skipButton.layer insertSublayer:shapeLayer atIndex:0];
    }
    return self;
}

- (void)timerAction{
    _leftTime --;
    if (_leftTime == 0) {
        [self dismiss];
    }
    
    [self.skipButton setTitle:[NSString stringWithFormat:@"%ds\n跳过",_leftTime] forState:UIControlStateNormal];
}

- (void)dismiss{
    [self removeFromSuperview];
    [self.timer invalidate];

}


- (void)tapGRAction{
    [self dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipToAD" object:nil];
}

















@end

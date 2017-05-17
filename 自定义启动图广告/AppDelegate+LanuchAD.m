//
//  AppDelegate+LanuchAD.m
//  自定义启动图广告
//
//  Created by haozp on 2017/5/17.
//  Copyright © 2017年 haozp. All rights reserved.
//

#import "AppDelegate+LanuchAD.h"
#import "DisplayADView.h"

static NSString * const imageUrlString = @"http://img04.tooopen.com/images/20130813/tooopen_15525804.jpg";

@implementation AppDelegate (LanuchAD)

- (void)setupLaunchImage{
    
    [self showADImage1];
   
}
//利用SDWebImage加载图片
- (void)showADImage1{
    //获取网络图片可以用SDWebImage 来添加缓存
    NSURL *url = [NSURL URLWithString:imageUrlString];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    
    DisplayADView *displayADView = [[DisplayADView alloc] initWithImage:image andFrame:self.window.bounds];
    
    
    //[UIApplication sharedApplication].keyWindow
    [self.window addSubview:displayADView];
}

//利用本地缓存加载图片
- (void)showADImage2{
    if([self checkIfImageExist]){
        //显示本地图片
        
        UIImage *image = [UIImage imageWithContentsOfFile:[self getLanuchImagePath]];
        
        DisplayADView *displayADView = [[DisplayADView alloc] initWithImage:image andFrame:self.window.bounds];
        
        
        //[UIApplication sharedApplication].keyWindow
        [self.window addSubview:displayADView];
        
    }else{
        [self getRemoteImage];
    }

}

//判断图片是否存在
- (BOOL)checkIfImageExist{
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getLanuchImagePath]];
}

//获取网络图片
- (void)getRemoteImage{
    
    NSURL *url = [NSURL URLWithString:imageUrlString];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"error = %@",error.localizedDescription);
        }else{
            if([data writeToFile:[self getLanuchImagePath] atomically:YES]){
                NSLog(@"图片已经保存到本地!");
            }
            
        }
    }];
    
    [dataTask resume];
}

//获取图片所在地址
- (NSString *)getLanuchImagePath{
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = cachePaths[0];
    
    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"launchImage.png"];
    
    return imagePath;
}


@end

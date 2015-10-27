//
//  UIImageView+FadeImage.m
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/26/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "UIImageView+FadeImage.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (FadeImage)

#pragma mark - AFNetworking UIImageView category

- (void)setFadeInImageWithURL:(NSURL *)url {
    [self setFadeInImageWithURL:url placeholderImage:nil];
}

- (void) setFadeInImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];



    __weak UIImageView *imageView = self;
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        imageView.alpha = 0.0;
        imageView.image = image;
        if (response == nil) {
            imageView.alpha = 1;
        } else {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ imageView.alpha = 1; } completion:nil];
//            [UIView animateWithDuration:0.5 animations:^{ imageView.alpha = 1; }];
        }
    } failure:nil];
}

@end



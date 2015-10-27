//
//  UIImageView+FadeImage.h
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/26/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FadeImage)

- (void)setFadeInImageWithURL:(NSURL *)url;
- (void) setFadeInImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

@end

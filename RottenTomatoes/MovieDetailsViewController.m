//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/23/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+FadeImage.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabel.text = [self.movie title];
    self.synopsisLabel.text = [self.movie synopsis];
    self.title = [self.movie title];
    [self.synopsisLabel sizeToFit];

    CGRect newFrame = self.contentView.frame;

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             self.contentView.frame.origin.y + newFrame.size.height + self.synopsisLabel.frame.size.height);

    // TODO: I had to add the 200 to make sure the black screen made it all the way down, other wise with the scroll overflow
    //       you can see the end of it
    newFrame.size.height = newFrame.size.height + self.synopsisLabel.frame.size.height + 200;
    [self.contentView setFrame:newFrame];

    NSURL *imageUrl = [self.movie posterUrl];
    [self.posterView setFadeInImageWithURL:imageUrl placeholderImage:self.placeholderImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

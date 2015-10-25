//
//  ViewController.m
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/20/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) NSArray *movies;
@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self hiddeErrorView];
    self.title = @"Movies";

    [self fetchMovies];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [self.movies count];
}

-(void) fetchMovies {
    [SVProgressHUD show];

    NSString *urlString = @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                    [SVProgressHUD dismiss];
                                                    NSLog(@"Response: %@", self.movies);
                                                } else {
                                                    [self showErrorView];
                                                    [SVProgressHUD dismiss];
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellText = [NSString stringWithFormat: @"Section %ld Row: %ld", indexPath.section, indexPath.row];
    NSLog(@"%@", cellText);

    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];


    NSString *originalUrlString = movie[@"posters"][@"thumbnail"];

    NSRange range = [originalUrlString rangeOfString:@".*cloudfront.net/"
                                             options:NSRegularExpressionSearch];

    NSString *newUrlString = [originalUrlString stringByReplacingCharactersInRange:range
                                                                        withString:@"https://content6.flixster.com/"];

    range = [newUrlString rangeOfString:@"_ori.jpg$"
                                     options:NSRegularExpressionSearch];

    newUrlString = [newUrlString stringByReplacingCharactersInRange:range
                                                              withString:@"_tmb.jpg"];



    NSLog(@"%@", newUrlString);
    NSURL *imageUrl = [[NSURL alloc] initWithString: newUrlString];

    [cell.posterView setImageWithURL:imageUrl];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) hiddeErrorView {
    self.errorView.hidden = YES;
    self.errorView.frame = CGRectMake(0, 0, self.errorView.frame.size.width, self.errorView.frame.size.height );
}
-(void) showErrorView {
    [self.errorView layoutIfNeeded];
    [UIView animateWithDuration:0.5
                          delay: 0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.errorView.hidden = NO;
                         CGRect frame = [self.navigationController navigationBar].frame;
                         self.errorView.frame = CGRectMake(0, frame.origin.y + frame.size.height, self.errorView.frame.size.width, self.errorView.frame.size.height );


                         [self.errorView layoutIfNeeded];
                     }
                     completion: nil];
}
@end

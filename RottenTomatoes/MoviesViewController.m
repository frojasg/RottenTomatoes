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
#import "Movie.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) NSArray *movies;
@property (strong,nonatomic) NSMutableArray *filteredMovies;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *moviesSearchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self hiddeErrorView];

    self.moviesSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    self.moviesSearchBar.delegate = self;
    self.tableView.tableHeaderView = self.moviesSearchBar;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents: UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [SVProgressHUD show];
    [self fetchMovies];
}

- (void) onRefresh:(UIRefreshControl *)refresh {
    [self fetchMovies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [self.filteredMovies count];
}

-(void) fetchMovies {
    NSURL *url = [NSURL URLWithString:self.endpoint];
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
                                                    self.filteredMovies = [NSMutableArray arrayWithArray:self.movies];
                                                    [self.tableView reloadData];
                                                    NSLog(@"Response: %@", self.movies);
                                                } else {
                                                    [self showErrorView];
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                [SVProgressHUD dismiss];
                                                [self.refreshControl endRefreshing];

                                            }];
    [task resume];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellText = [NSString stringWithFormat: @"Section %ld Row: %ld", indexPath.section, indexPath.row];
    NSLog(@"%@", cellText);

    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    Movie *movie = [[Movie alloc] initWithDict:self.filteredMovies[indexPath.row]];
    cell.titleLabel.text = [movie title];
    cell.synopsisLabel.text = [movie synopsis];

    NSURL *imageUrl = [movie thumbnailUrl];

    [cell.posterView setImageWithURL:imageUrl];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = [[Movie alloc] initWithDict: self.filteredMovies[indexPath.row]];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.filteredMovies removeAllObjects];
    if(searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@",searchText];
        self.filteredMovies = [NSMutableArray arrayWithArray: [self.movies filteredArrayUsingPredicate:predicate]];
    } else {
        self.filteredMovies = [NSMutableArray arrayWithArray:self.movies];
    }
    [self.tableView reloadData];
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

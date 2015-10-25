//
//  Movie.m
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/24/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import "Movie.h"

@implementation Movie
@synthesize movie;

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self)
    {
        self.movie = dict;
    }
    return self;
}

-(NSURL*) thumbnailUrl {
    return [[NSURL alloc] initWithString: self.movie[@"posters"][@"thumbnail"]];
}
-(NSURL*) posterUrl {
    NSString *originalUrlString = self.movie[@"posters"][@"detailed"];
    NSRange range = [originalUrlString rangeOfString:@".*cloudfront.net/"
                                             options:NSRegularExpressionSearch];
    NSString *newUrlString = [originalUrlString stringByReplacingCharactersInRange:range
                                                                        withString:@"https://content6.flixster.com/"];
    NSLog(@"%@", newUrlString);
    return [[NSURL alloc] initWithString: newUrlString];
}
-(NSString *) title {
    return self.movie[@"title"];
}
-(NSString *) synopsis {
    return self.movie[@"synopsis"];
}


@end

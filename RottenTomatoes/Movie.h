//
//  Movie.h
//  RottenTomatoes
//
//  Created by Francisco Rojas Gallegos on 10/24/15.
//  Copyright © 2015 Francisco Rojas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property(strong, nonatomic) NSDictionary *movie;
-(instancetype)initWithDict:(NSDictionary *) dict;
-(NSURL*) thumbnailUrl;
-(NSURL*) posterUrl;
-(NSString *) title;
-(NSString *) synopsis;

@end

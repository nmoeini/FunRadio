//
//  PlayJokesViewController.h
//  yourFunRadio
//
//  Created by Navid on 5/2/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "StarRatingView.h"
#import "StarRatingViewDebug.h"


@interface PlayJokesViewController : UIViewController {
    StarRatingView *RatingOfJokeContext;
    StarRatingView *RatingOfJokerPerformance;
    StarRatingView *OverallJokeRating;
    
}

@property IBOutlet UIView *ratingView;
@property (strong, nonatomic) NSString *jokeName;
@property (strong, nonatomic) NSString *jokeUrl;

@end

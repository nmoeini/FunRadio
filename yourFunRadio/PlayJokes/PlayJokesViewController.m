//
//  PlayJokesViewController.m
//  yourFunRadio
//
//  Created by Navid on 5/2/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import "PlayJokesViewController.h"

#define kLabelAllowance 50.0f
#define kStarViewHeight 30.0f
#define kStarViewWidth 160.0f
#define kLeftPadding 5.0f
#define STEAM_URL @"http://cent4.serverhostingcenter.com/tunein.php/lmyxelac/playlist.pls"

@interface PlayJokesViewController ()

@property (nonatomic, strong) NSMutableArray *userRating;

@end

@implementation PlayJokesViewController

@synthesize ratingView, userRating, jokeName, jokeUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
;
- (void)viewDidLoad
{
        [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rateJokes:(UIButton *)sender {
    
    self.ratingView.hidden = FALSE;
    
    RatingOfJokeContext = [[StarRatingView alloc]initWithFrame:CGRectMake(130, 50, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:0 withLabel:NO animated:NO];
    [ratingView addSubview:RatingOfJokeContext];
        
    RatingOfJokerPerformance = [[StarRatingView alloc]initWithFrame:CGRectMake(130, 100, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight)andRating:0 withLabel:NO animated:NO];
    [ratingView addSubview:RatingOfJokerPerformance];
    
    OverallJokeRating = [[StarRatingView alloc]initWithFrame:CGRectMake(130, 150, kStarViewWidth+kLabelAllowance+kLeftPadding, kStarViewHeight) andRating:0 withLabel:NO animated:NO];
    [ratingView addSubview:OverallJokeRating];
}

- (IBAction)newRatingDone:(id)sender {
    
    self.userRating = [[NSMutableArray alloc] initWithCapacity:3];
    [userRating addObject:[NSNumber numberWithInt:RatingOfJokeContext.userRating] ];
    [userRating addObject:[NSNumber numberWithInt:RatingOfJokerPerformance.userRating]];
    [userRating addObject:[NSNumber numberWithInt:OverallJokeRating.userRating]];
   
    NSLog(@"User rated of this joke for context: %@, performance: %@, overall: %@" , [userRating objectAtIndex:0], [userRating objectAtIndex:1], [userRating objectAtIndex:2]);

    self.ratingView.hidden = TRUE;
}
- (IBAction)cancelRating:(id)sender {
    self.ratingView.hidden = TRUE;
}
- (IBAction)addToFavorit:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"favoriteJokes.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: jokeName, jokeUrl, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"jokeName", @"jokePath", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"%@", error);
    }
}
-(void) viewDidUnload {
    
    [super viewDidUnload];
    
}
@end

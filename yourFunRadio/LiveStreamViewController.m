//
//  LiveStreamViewController.m
//  yourFunRadio
//
//  Created by Navid on 5/18/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import "LiveStreamViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/CAAnimation.h>

#define STREAM_URL @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface liveStreamViewController ()

@end

@implementation liveStreamViewController {
    NSArray *playlist;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    //    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), json);
    //    playlist = [json objectForKey:@"songs"];
    
    //    NSLog(@"%@", songs);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *urlToLoad = [NSURL URLWithString:STREAM_URL];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        urlToLoad];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *urlToLoad = [NSURL URLWithString:STREAM_URL];
    NSLog(@"%@", urlToLoad);
    
    player = [[MPMoviePlayerController alloc] init];
    player.movieSourceType = MPMovieSourceTypeStreaming;
    player.view.frame = CGRectMake(10, 0, 300, 50);
    
    //   [player prepareToPlay];
    
    //   [player.view setFrame: self.view.bounds];
    
    player.backgroundView.backgroundColor = [UIColor clearColor];
    player.view.backgroundColor = [UIColor clearColor];
    //   [player setContentURL:urlToLoad];
    [self.view addSubview:player.view];
    //   [player prepareToPlay];
    //   [player play];
    
    if (player)
    {
        [player stop];
    }
    
       dispatch_queue_t imageDownloadQ = dispatch_queue_create("stream downloader", NULL);
       dispatch_async(imageDownloadQ, ^{
    [player setContentURL:urlToLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [player prepareToPlay];
        [player play];
    });
        });
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error) {
        NSLog(@"Did finish with error: %@", error);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

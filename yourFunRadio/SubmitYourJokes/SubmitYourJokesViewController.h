//
//  SubmitYourJokesViewController.h
//  yourFunRadio
//
//  Created by Navid on 5/2/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>



@interface SubmitYourJokesViewController : UIViewController <AVAudioRecorderDelegate> {
    
	
	NSString *mediaPath;
	NSTimer *currentTimeUpdateTimer;
    UILabel *currentTimeLabel;
    SystemSoundID soundID;
	AVAudioRecorder *recorder;
    NSMutableDictionary *recordSetting;
    
    
    IBOutlet UIButton *btnStartRecord;
    IBOutlet UIButton *btnStopRecord;
    IBOutlet UIButton *btnPauseRecord;
    IBOutlet UIButton *btnResumeRecord;
    IBOutlet UIButton *btnPlay;
    
    AVAudioSession *audioSession;
}

typedef OSStatus (*HostCallback_GetTransportState) (
void     *inHostUserData,
Boolean  *outIsPlaying,
Boolean  *outTransportStateChanged,
Float64  *outCurrentSampleInTimeLine,
Boolean  *outIsCycling,
Float64  *outCycleStartBeat,
Float64  *outCycleEndBeat
);


@property (nonatomic, retain)IBOutlet NSString * mediaPath;
@property (nonatomic ,retain)IBOutlet UILabel *currentTimeLabel;

@property (retain, nonatomic) IBOutlet UILabel *userStatus;
@property (retain, nonatomic) IBOutlet UILabel *progressDisplay;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction) startRecording;
- (IBAction) stopRecording;
- (IBAction) pauseRecording;
- (IBAction) resumeRecording;
- (IBAction) playRecording;


-(void)createDefaultFile;

@end

//
//  SubmitYourJokesViewController.m
//  yourFunRadio
//
//  Created by Navid on 5/2/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import "SubmitYourJokesViewController.h"

@interface SubmitYourJokesViewController ()
@property NSError *err;
@property NSString *size;
@property NSString *length;
@property (weak, nonatomic) IBOutlet UIButton *saveRecordedSound;
@property (weak, nonatomic) IBOutlet UIButton *sendYourJoke;

@end

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation SubmitYourJokesViewController


- (void)createDefaultFile {
    
    NSFileManager *fileMgr= [[NSFileManager alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"myVoiceDefault.caf" ofType:nil];
    NSLog(@"filePath %@",filePath);
    NSError *error;
    
    if(![fileMgr copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@/Documents/myVoiceDefault.caf", NSHomeDirectory()] error:&error]) {
        
        //Exception Hndling
        NSLog(@"Error : %@", [error description]);
        
    }
    
 //   [fileMgr release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
@synthesize mediaPath, currentTimeLabel;

int isAudioRecord = 0;
NSError *err = nil;


- (void)viewWillAppear:(BOOL)animated {
    
	audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:nil];
    
	if(err) {
        
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
    
	[audioSession setActive:YES error:nil];
	
    btnStartRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE;
    btnResumeRecord.hidden = TRUE;
    currentTimeLabel.hidden = TRUE;

}

- (void)viewDidLoad {
    
	[super viewDidLoad];
    self.title = @"Send Your Jokes";
    
    // setup clock
	currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                              target:self
                                                            selector:@selector(updateAudioDisplay)
                                                            userInfo:NULL
                                                             repeats:YES];
    
}


//To start voice recording
- (IBAction) startRecording {
	
    isAudioRecord = 1;

    currentTimeLabel.hidden = FALSE;
    btnStartRecord.hidden = TRUE;
    btnPlay.hidden = TRUE;
    btnStopRecord.hidden = FALSE;
    btnPauseRecord.hidden = FALSE ;
    btnResumeRecord.hidden = TRUE;
    
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
	[recordSetting setValue:[NSNumber numberWithFloat:32000.0] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
    recordSetting = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mediaPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    
    mediaPath = [NSString stringWithFormat:@"%@/myVoice.caf", DOCUMENTS_FOLDER];
    NSURL *url = [NSURL fileURLWithPath:mediaPath];
    err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:nil];
    
    if(audioData) {
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:nil];
        
    }
	
    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
	
    if(!recorder){
        
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle: @"Warning"
                                                       message: [err localizedDescription]
                                                      delegate: nil cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
     //   [alert release];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    
    if (! audioHWAvailable) {
        
        UIAlertView *cantRecordAlert = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                                  message: @"Audio input hardware not available"
                                                                 delegate: nil cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [cantRecordAlert show];
     //   [cantRecordAlert release];
        return;
    }
    
	// start recording
	[recorder record];
    
}

- (IBAction)playRecording

{
	if(!mediaPath)
		mediaPath = [NSString stringWithFormat:@"%@/myVoiceDefault.caf", DOCUMENTS_FOLDER];
	
	//NSLog(@"Playing sound from Path: %@",recorderFilePath);
	
	if(soundID)	{
        
		AudioServicesDisposeSystemSoundID(soundID);
        
	}
	
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:mediaPath isDirectory:NO];
	
	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
    
    
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
 }

- (void) updateAudioDisplay {
    
    double currentTime = recorder.currentTime;
	
    if (recorder == nil) {
        
        currentTimeLabel.text = @"";
        
    } else if (!recorder.isRecording) {
        
        currentTimeLabel.text = [NSString stringWithFormat: @"Recording  %02d:%02d",
        (int) currentTime/60,
        (int) currentTime%60];
        
    } else {
        
		currentTimeLabel.text = [NSString stringWithFormat: @"Recording %02d:%02d",
        (int) currentTime/60,
        (int) currentTime%60];
		[recorder updateMeters];
        
	}
    
}


//To stop the voice recording.
- (IBAction) stopRecording {
    
	[recorder stop];

    currentTimeLabel.hidden = TRUE;
    btnStartRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE ;
    btnResumeRecord.hidden = TRUE;
    isAudioRecord = 0;
    
    [self.saveRecordedSound setEnabled:YES];
    [self.sendYourJoke setEnabled:YES];
}

// To pause the voice recording.
- (IBAction) pauseRecording {
	
    [recorder pause];
    [self updateAudioDisplay];

    btnStartRecord.hidden = TRUE;
    btnResumeRecord.hidden = FALSE;
    btnPlay.hidden = FALSE;
    btnStopRecord.hidden = TRUE;
    btnPauseRecord.hidden = TRUE;

}

// To resume the audio from pause
- (IBAction) resumeRecording {
	
    [recorder record];

    btnStartRecord.hidden = TRUE;
    btnPlay.hidden = TRUE;
    btnStopRecord.hidden = FALSE;
    btnPauseRecord.hidden = FALSE;
    btnResumeRecord.hidden = TRUE;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) overWrite
{
    
}
- (void) overWriteAlert:(NSString *) fileName
{
    NSString *overWriteMessage = [NSString stringWithFormat:@"An item already exists with this name %@ . Do you want to overwrite?" , fileName];
    UIAlertView *overWrite = [[UIAlertView alloc] initWithTitle:@"Warning" message: overWriteMessage delegate:self cancelButtonTitle:@"Overwrite" otherButtonTitles:@"Cancel", nil];
    [overWrite show];
}

-(void) saveFile : (NSString *) fileName
{
    NSFileManager *fileMgr= [[NSFileManager alloc] init];
    NSError *error;
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
    filePath = [filePath stringByAppendingString:fileName];
    
    NSLog(@"%@", filePath);
    
    [fileMgr copyItemAtPath:mediaPath toPath:filePath error:&error];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if ([alertView.title isEqualToString:@"Save as"]) {
    if (buttonIndex == 0) {
            NSString *fileName = [NSString stringWithFormat:@"%@",[alertView textFieldAtIndex:0] ];
            [self saveFile:fileName];
                }
    }else if ([alertView.title isEqualToString:@"Send a joke"]){
        
    }

}
- (IBAction)saveRecordedSound:(id)sender {
    
    UIAlertView *saveAs = [[UIAlertView alloc] initWithTitle:@"Save as"
                                                    message:@"Enter your file name"
                                                   delegate:self
                                          cancelButtonTitle:@"Save"
                                          otherButtonTitles:@"Cancel", nil];
    
    [saveAs setAlertViewStyle: UIAlertViewStylePlainTextInput];
    
    UITextField *fileName = [saveAs textFieldAtIndex:0];
    fileName.clearButtonMode = UITextFieldViewModeWhileEditing;
    fileName.keyboardType = UIKeyboardTypeAlphabet;
    fileName.keyboardAppearance = UIKeyboardAppearanceAlert;
    fileName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    fileName.autocapitalizationType = UITextAutocapitalizationTypeNone;

    [saveAs show];
}

- (IBAction)sendAudioFile:(id)sender {
    
    UIAlertView *sendJoke = [[UIAlertView alloc] initWithTitle:@"Send a joke" message:@"Chose a name for your joke" delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
    [sendJoke setAlertViewStyle: UIAlertViewStyleLoginAndPasswordInput];
    
    UITextField *jokeName = [sendJoke textFieldAtIndex:0];
    jokeName.placeholder = Nil;
    jokeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    jokeName.keyboardType = UIKeyboardTypeAlphabet;
    jokeName.keyboardAppearance = UIKeyboardAppearanceAlert;
    jokeName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    jokeName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    UITextField *passWord = [sendJoke textFieldAtIndex:1];
    passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWord.keyboardType = UIKeyboardTypeURL;
    passWord.keyboardAppearance = UIKeyboardAppearanceAlert;
    passWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passWord.autocapitalizationType = UITextAutocorrectionTypeNo;
    
    [sendJoke show];
}


@end

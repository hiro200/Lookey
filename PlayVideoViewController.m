//
//  VideoViewController.m
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 10..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "CommonUtils.h"

#import <MediaPlayer/MediaPlayer.h>

#import "ImageSearchResultManager.h"
#import "ImageSearchResultViewController.h"
#import "GlobalValues.h"
#import "NSDictionary+Object.h"
#import "HttpRespons.h"
#import "NavigationController.h"
#import "LookeyWebViewController.h"

@interface PlayVideoViewController ()

@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;

@end

@implementation PlayVideoViewController

- (void) viewDidLoad {
	[super viewDidLoad];
    
    
	NSURL *videoUrl = [NSURL URLWithString: _videoUrlPath];
    
    NSLog(@"Video : %@", videoUrl);
    
	self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayBackDidFinish:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object: _videoPlayer];
	_videoPlayer.controlStyle = MPMovieControlStyleFullscreen;
	[_videoPlayer setMovieSourceType: MPMovieSourceTypeStreaming];
	[_videoPlayer setFullscreen: YES animated: YES];
	[_videoPlayer prepareToPlay];
	[_videoPlayer.view setFrame: self.view.frame];
	[self.view addSubview: _videoPlayer.view];
	[_videoPlayer play];
}


- (void) moviePlayBackDidFinish: (NSNotification*) notification {
      [self dismissAndLoadWeb];
    
}


-(NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        NSLog(@"Rotation1");
        [_videoPlayer setFullscreen: YES animated: YES];
        
    }else{
        NSLog(@"Rotation2");
        [_videoPlayer setFullscreen: YES animated: YES];
        
    }
}

- (void)dismissAndLoadWeb{
    UIViewController *vc = self.presentingViewController;
    [_videoPlayer.view removeFromSuperview];
    [self dismissViewControllerAnimated:NO completion:nil];
    [CommonUtils loadWeb: _forwardUrlPath withViewController:vc isGotoMain:YES isCheckLookey:YES];
}


@end

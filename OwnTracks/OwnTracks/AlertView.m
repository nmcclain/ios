//
//  AlertView.m
//  OwnTracks
//
//  Created by Christoph Krey on 20.12.13.
//  Copyright © 2013-2017 Christoph Krey. All rights reserved.
//

#import "AlertView.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@interface AlertView()
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation AlertView
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

+ (void)alert:(NSString *)title message:(NSString *)message {
    [AlertView alert:title message:message dismissAfter:0];
}

+ (void)alert:(NSString *)title message:(NSString *)message dismissAfter:(NSTimeInterval)interval {
    (void)[[AlertView alloc] initWithAlert:title message:message dismissAfter:interval];
}

- (AlertView *)initWithAlert:(NSString *)title
                     message:(NSString *)message
                dismissAfter:(NSTimeInterval)interval {
    self = [super init];
    
    DDLogVerbose(@"[AlertView] applicationState %ld", (long)[UIApplication sharedApplication].applicationState);
    DDLogVerbose(@"[AlertView] %@/%@ (%f)", title, message, interval);
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:interval ? nil :
                                            NSLocalizedString(@"OK", @"OK button title")
                                          otherButtonTitles:nil];
        [self performSelectorOnMainThread:@selector(setup:)
                               withObject:[NSNumber numberWithFloat:interval] waitUntilDone:NO];
    }
    return self;
}

- (void)setup:(NSNumber *)interval {
    NSTimeInterval timeInterval = interval.doubleValue;
    [self.alertView show];
    if (timeInterval) {
        [self performSelector:@selector(dismissAfterDelay:) withObject:self.alertView afterDelay:timeInterval];
    }
}

- (void)dismissAfterDelay:(UIAlertView *)alertView {
    DDLogVerbose(@"AlertView dismissAfterDelay");
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end

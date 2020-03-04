//
//  OEXMySettingsViewController.m
//  edXVideoLocker
//
//  Created by Abhradeep on 20/02/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import "OEXMySettingsViewController.h"

#import "edX-Swift.h"

#import "NSString+OEXFormatting.h"
#import "OEXInterface.h"
#import "OEXStyles.h"

typedef NS_ENUM(NSUInteger, OEXMySettingsAlertTag) {
    OEXMySettingsAlertTagNone,
    OEXMySettingsAlertTagWifiOnly
};

@interface OEXMySettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableViewCell* wifiOnlyCell;
@property (weak, nonatomic) IBOutlet UISwitch* wifiOnlySwitch;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OEXMySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.wifiOnlySwitch setOn:[OEXInterface shouldDownloadOnlyOnWifi]];
    [self.wifiOnlySwitch setOnTintColor:[OEXStyles sharedStyles].primaryBaseColor];
    
    [self.subtitleLabel setTextAlignment:NSTextAlignmentNatural];
    [self.titleLabel setText:[Strings wifiOnlyTitle]];
    [self.subtitleLabel setText:[Strings wifiOnlyDetailMessage]];
    
    self.wifiOnlyCell.accessibilityLabel = [NSString stringWithFormat:@"%@ , %@", self.titleLabel.text, self.subtitleLabel.text];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = [Strings settings];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[OEXAnalytics sharedAnalytics] trackScreenWithName:OEXAnalyticsScreenSettings];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return self.wifiOnlyCell.bounds.size.height;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return self.wifiOnlyCell;
}

- (IBAction)wifiOnlySwitchValueChanged:(id)sender {
    if(!self.wifiOnlySwitch.isOn) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[Strings cellularDownloadEnabledTitle] message:[Strings cellularDownloadEnabledMessage] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:[Strings allow] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [OEXInterface setDownloadOnlyOnWifiPref:self.wifiOnlySwitch.isOn];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:[Strings doNotAllow] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.wifiOnlySwitch setOn:YES animated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [OEXInterface setDownloadOnlyOnWifiPref:self.wifiOnlySwitch.isOn];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [OEXStyles sharedStyles].standardStatusBarStyle;
}

@end

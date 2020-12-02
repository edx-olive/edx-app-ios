//
//  OEXUserLicenseAgreementViewController.m
//  edXVideoLocker
//
//  Created by Jotiram Bhagat on 19/02/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

#import "OEXUserLicenseAgreementViewController.h"
#import <Masonry/Masonry.h>
#import "edX-Swift.h"
#import "Logger+OEXObjC.h"
#import <WebKit/WebKit.h>
#import "OEXRegistrationAgreement.h"
@interface OEXUserLicenseAgreementViewController () <WKNavigationDelegate>
{
    WKWebView *webView;
    IBOutlet UIActivityIndicatorView* activityIndicator;
}
@property(nonatomic, strong) NSURL* contentUrl;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation OEXUserLicenseAgreementViewController

- (instancetype)initWithContentURL:(NSURL*)contentUrl {
    self = [super init];
    if(self) {
        self.contentUrl = contentUrl;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    
    [_closeButton setTitle:[Strings close] forState:UIControlStateNormal];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:self.contentUrl];
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40)];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.closeButton.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    
    
    webView.navigationDelegate = self;
    [webView loadRequest:request];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL isFileURL]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL]];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [activityIndicator stopAnimating];
    OEXLogInfo(@"EULA", @"Error is %@", error.localizedDescription);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[Strings ok] style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [activityIndicator stopAnimating];
    OEXLogInfo(@"EULA", @"Web View did finish loading");
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [activityIndicator startAnimating];
    OEXLogInfo(@"EULA", @"Web View did start loading");
}

@end

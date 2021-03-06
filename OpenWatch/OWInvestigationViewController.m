//
//  OWInvestigationViewController.m
//  OpenWatch
//
//  Created by David Brodsky on 5/2/13.
//  Copyright (c) 2013 OpenWatch FPC. All rights reserved.
//

#import "OWInvestigationViewController.h"
#import "OWInvestigation.h"
#import "MBProgressHUD.h"
#import "OWAccountAPIClient.h"
#import "OWStrings.h"

@interface OWInvestigationViewController ()

@end

@implementation OWInvestigationViewController
@synthesize bodyWebView;

- (void) setMediaObjectID:(NSManagedObjectID *)newMediaObjectID {
    [super setMediaObjectID:newMediaObjectID];
    [self refreshFields];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    OWInvestigation *investigation = (OWInvestigation*)[context existingObjectWithID:self.mediaObjectID error:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[OWAccountAPIClient sharedClient] getObjectWithObjectID:investigation.objectID success:^(NSManagedObjectID *objectID) {
        [self refreshFields];
    } failure:^(NSString *reason) {
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
        OWInvestigation *investigation = (OWInvestigation*)[context existingObjectWithID:self.mediaObjectID error:nil];
        if(!investigation.html){
            
            NSString *loadError = [NSString stringWithFormat:@"<b>%@</b>", INVESTIGATION_LOAD_ERROR_STRING];
            [self.bodyWebView loadHTMLString:loadError baseURL:nil];
        }
        
    } retryCount:kOWAccountAPIClientDefaultRetryCount];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) dealloc {
    if ([bodyWebView isLoading]) {
        [bodyWebView stopLoading];
    }
    self.bodyWebView.delegate = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupWebView];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bodyWebView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:bodyWebView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupWebView
{
    self.bodyWebView = [[UIWebView alloc] init];
    self.bodyWebView.scrollView.scrollEnabled = YES;
    self.bodyWebView.delegate = self;
    self.bodyWebView.backgroundColor = [UIColor clearColor];
    self.bodyWebView.opaque = NO;
    
}

- (void)refreshFields
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    OWInvestigation *investigation = (OWInvestigation*)[context existingObjectWithID:self.mediaObjectID error:nil];
    [self displayHTMLforInvestigation: investigation];
    self.title = investigation.title;
}

- (void)displayHTMLforInvestigation: (OWInvestigation *) inv
{
    [self.bodyWebView loadHTMLString:inv.html baseURL:nil];
}

@end

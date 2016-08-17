#import "AVManager.h"
#import "PDStatusBarDebugger.h"

%hook BaseMsgContentViewController
- (void)viewWillAppear:(BOOL)animated {
	%orig;
	UINavigationItem *navigationItem = [self valueForKey:@"navigationItem"];
    if (navigationItem.rightBarButtonItems.count < 3) {
        UIBarButtonItem *tpButton = [[UIBarButtonItem alloc] initWithTitle:@"T" style:UIBarButtonItemStylePlain target:self action:@selector(pressTPButton:)];
        NSMutableArray *barButtons = [NSMutableArray arrayWithArray:navigationItem.rightBarButtonItems];
        [barButtons insertObject:tpButton atIndex:0];
        [navigationItem setRightBarButtonItems:barButtons];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([AVManager isTPOn]) {
        UIView *view = [self valueForKey:@"view"];
        [[AVManager shareManager] startCaptureInView:view];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    %orig;
    UINavigationController *navCon = [self valueForKey:@"navigationController"];
    if ([navCon.viewControllers indexOfObject:(UIViewController *)self] == NSNotFound) {
        [[AVManager shareManager] stop];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ([AVManager isTPOn]) {
        [[AVManager shareManager] stop];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([AVManager isTPOn]) {
        UIView *view = [self valueForKey:@"view"];
        [[AVManager shareManager] startCaptureInView:view];
    }
}

%new
- (void)pressTPButton:(id)sender {     
    BOOL isTPOn = ![AVManager isTPOn];
    [[NSUserDefaults standardUserDefaults] setObject:@(isTPOn) forKey:@"PANDARA_TP_ON"];     
    if (isTPOn) {         
        UIView *view = [self valueForKey:@"view"];         
        [[AVManager shareManager] startCaptureInView:view];    
    } else {         
        [[AVManager shareManager] stop];     
    }
}

%end

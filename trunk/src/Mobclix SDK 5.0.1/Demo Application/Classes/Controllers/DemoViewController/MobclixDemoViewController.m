//
//  MobclixDemoViewController.m
//  MobclixDemo
//
//  Copyright 2011 Mobclix. All rights reserved.
//

#import "MobclixDemoViewController.h"

#import "MobclixAdvertisingViewController.h"
#import "MobclixCommentViewController.h"
#import "MobclixRatingViewController.h"
#import "MobclixDemographicsViewController.h"
#import "MobclixFullScreenAdvertisingViewController.h"

#import "Mobclix.h"

@implementation MobclixDemoViewController
@synthesize tableView=_tableView;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.title = [NSString stringWithFormat:@"Mobclix SDK Demo v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Demo" style:UIBarButtonItemStylePlain target:nil action:NULL] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(section == 1) {
		return 3;
	} else {
		return 2;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	if(indexPath.section == 0) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		if(indexPath.row == 0) {
			cell.textLabel.text = @"Unit Advertising";
			cell.imageView.image = [UIImage imageNamed:@"advertising.png"];
		} else {
			cell.textLabel.text = @"Full Screen Advertising";
			cell.imageView.image = [UIImage imageNamed:@"fullscreen.png"];
		}
	} else if(indexPath.section == 1) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		if(indexPath.row == 0) {
			cell.textLabel.text = @"Comments";
			cell.imageView.image = [UIImage imageNamed:@"comments.png"];
		} else if(indexPath.row == 1) {
			cell.textLabel.text = @"Ratings";
			cell.imageView.image = [UIImage imageNamed:@"ratings.png"];
		} else {
			cell.textLabel.text = @"Demographics";
			cell.imageView.image = [UIImage imageNamed:@"demographics.png"];
		}
	}
    
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController* viewController;
	BOOL presentModally = NO;
	
	if(indexPath.section == 0) {
		if(indexPath.row == 0) {
			viewController = [[MobclixAdvertisingViewController alloc] init];
		} else {
			viewController = [[MobclixFullScreenAdvertisingViewController alloc] init];
		}
	} else if(indexPath.section == 1) {
		if(indexPath.row == 0) {
			viewController = [[MobclixCommentViewController alloc] initWithNibName:@"MobclixCommentViewController" bundle:nil];
		} else if(indexPath.row == 1) {
			viewController = [[MobclixRatingViewController alloc] initWithNibName:@"MobclixRatingViewController" bundle:nil];
		} else {
			viewController = [[MobclixDemographicsViewController alloc] initWithNibName:@"MobclixDemographicsViewController" bundle:nil];
		}
	}
	
	if(presentModally) {
		[self presentModalViewController:viewController animated:YES];
	} else {
		[self.navigationController pushViewController:viewController animated:YES];
	}
	
	[viewController release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return @"Revenue";
	} else if(section == 1) {
		return @"Feedback";
	} else {
		return @"";
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.tableView.delegate = nil;
	self.tableView = nil;
}


- (void)dealloc {
	self.tableView.delegate = nil;
	self.tableView = nil;

    [super dealloc];
}


@end


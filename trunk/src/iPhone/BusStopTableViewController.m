//
//  BusStopTableViewController.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusStopTableViewController.h"
#import "FavouritesConfiguration.h"


@implementation BusStopTableViewController

@synthesize tableViewController;
@synthesize blackView;
@synthesize request;
@synthesize busStopName;
@synthesize tblCell;
@synthesize data;
@synthesize progressIndicator;
@synthesize favButton;

- (void)layoutSubView:(BOOL)show
{
	
	if(show == NO) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	
	CGFloat animationDuration = 0.3f;
    // by default content consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
	CGPoint infoSubOrigin = CGPointMake(0.0, 0.0); //CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat subViewHeight = self.view.bounds.size.height;
    
	
    // Depending on if the banner has been loaded, we adjust the content frame and banner location
    // to accomodate the ad being on or off screen.
    // This layout is for an ad at the bottom of the view.
    if (show)
    {
		contentFrame.origin.y += subViewHeight;
        contentFrame.size.height -= subViewHeight;
    }
    else
    {
		infoSubOrigin.y -= subViewHeight;
    }
    
    // And finally animate the changes, running layout for the content view if required.
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         /*map.frame = contentFrame;
						  [map layoutIfNeeded];*/
                         self.view.frame = CGRectMake(infoSubOrigin.x -1, infoSubOrigin.y -1, self.view.frame.size.width, self.view.frame.size.height);
                     }];
}

-(void)busStopTouched:(id<MKAnnotation>)station {
	
	// Check favourite
	FavouritesConfiguration* config = [FavouritesConfiguration sharedInstance];
	if([config included:[station performSelector:@selector(url)] withType:TYPE_BUS]) {
		[favButton setImage:[UIImage imageNamed:@"28-star.png"] forState:UIControlStateNormal];
	} else {
		[favButton setImage:[UIImage imageNamed:@"28-white-star.png"] forState:UIControlStateNormal];
	}

	NSString* name = [station performSelector:@selector(title)];
    busStopName.text = name;
	
	lastStation = station;
	
	[self.progressIndicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[self layoutSubView:YES];
	
	// Reinicio la tabla
	data = [[BusResponse alloc] init];	
	data.busEntries = [NSMutableArray arrayWithCapacity:0];
	
	[tableViewController reloadData];
	
	request = [[WebRequestTuzsa alloc] init];
	
	[request checkOut:[station performSelector:@selector(url)] withDelegate:self];
}


-(void)requestFinishedWithBus:(BusResponse*)response {
	[self.progressIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.data = response;
	
	[tableViewController reloadData];
}

-(void)requestDidFinishWithError:(NSError*)error {
/*	
	self.refresh.hidden = YES;
	self.refresh.enabled = NO;
*/
	[self.progressIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(IBAction)refreshButtonTouched {
	
	[self busStopTouched:lastStation];
}

-(IBAction)favButtonTouched {
	FavouritesConfiguration* config = [FavouritesConfiguration sharedInstance];
	if([config included:[lastStation performSelector:@selector(url)] withType:TYPE_BUS]) {
		[favButton setImage:[UIImage imageNamed:@"28-white-star.png"] forState:UIControlStateNormal];
		[config remove:[lastStation performSelector:@selector(url)] withType:TYPE_BUS];
	} else {
		[favButton setImage:[UIImage imageNamed:@"28-star.png"] forState:UIControlStateNormal];
		[config add:[lastStation performSelector:@selector(url)] withType:TYPE_BUS];
	}
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.tableViewController.separatorColor = [UIColor redColor];

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 1};
	CGColorRef almostBlack = CGColorCreate(space,components);
	
	self.blackView.layer.shadowColor = almostBlack;
	self.blackView.layer.shadowOffset = CGSizeMake(0.0, 6.0);
	self.blackView.layer.shadowOpacity = 1.0;
	self.blackView.layer.shadowRadius = 5.0;

	
	self.view.frame = CGRectMake(0.0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
	
	CGColorSpaceRef space2 = CGColorSpaceCreateDeviceRGB();
	CGFloat components2[4] = {1, 1, 1, 1};
	CGColorRef almostWhite = CGColorCreate(space2,components2);
	self.view.layer.borderColor = almostWhite;
	self.view.layer.borderWidth = 1.0;
	
	[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
	
	data = [[BusResponse alloc] init];
	
	data.busEntries = [NSMutableArray arrayWithCapacity:0];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tblCell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	NSInteger result = [data.busEntries count] - 1;
	
	if(result < 0) result = 0;
	
    return result;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
	
	TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if(cell == nil) {
		
		[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
		
		cell = tblCell;
	}
	
	BusEntry* busEntry = [data.busEntries objectAtIndex:indexPath.row + 1];
	
	NSString* busN = busEntry.busNumber;
	
	if([busN isEqualToString:@"LINEA"]) {
		busN = @"L";
	}
	
	[cell setLabelTextNumber:busN];
	[cell setLabelTextDestination:[[busEntry.busDestination lowercaseString] capitalizedString]];
	[cell setLabelTextWaitTime:busEntry.busWaitTime];
	
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setBusStopName:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	self.favButton = nil;
	self.tblCell = nil;
	self.request = nil;
	self.blackView = nil;
	self.tableViewController = nil;
	self.progressIndicator = nil;
}


- (void)dealloc {
	
	[favButton release];
	[progressIndicator release];
	[tblCell release];
	[request release];
	[blackView release];
	[tableViewController release];
    [busStopName release];
    [super dealloc];
}


@end


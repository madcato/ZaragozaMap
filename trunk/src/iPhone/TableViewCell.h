//
//  TableViewCell.h
//  zgzbus
//
//  Created by Daniel Vela on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCell : UITableViewCell {

	UILabel *cellTextNumber;
	UILabel *cellTextDestination;
	UILabel *cellTextWaitTime;
}

@property (nonatomic, retain) IBOutlet UILabel *cellTextNumber;
@property (nonatomic, retain) IBOutlet UILabel *cellTextDestination;
@property (nonatomic, retain) IBOutlet UILabel *cellTextWaitTime;

- (void)setLabelTextNumber:(NSString *)_text;
- (void)setLabelTextDestination:(NSString *)_text;
- (void)setLabelTextWaitTime:(NSString *)_text;
@end

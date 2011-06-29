//
//  TableViewCell.m
//  zgzbus
//
//  Created by Daniel Vela on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

@synthesize cellTextNumber;
@synthesize cellTextDestination;
@synthesize cellTextWaitTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}

- (void)setLabelTextNumber:(NSString *)_text;{
	cellTextNumber.text = _text;
	cellTextNumber.font = [UIFont boldSystemFontOfSize:24];
}

- (void)setLabelTextDestination:(NSString *)_text;{
	cellTextDestination.text = _text;
}

- (void)setLabelTextWaitTime:(NSString *)_text;{
	cellTextWaitTime.text = _text;
}

@end

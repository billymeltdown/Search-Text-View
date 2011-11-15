//
//  ZTSearchResultViewCell.m
//  Search Text View
//
//  Created by Billy Gray on 11/14/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "ZTSearchResultViewCell.h"

@implementation ZTSearchResultViewCell

@synthesize webView;
@synthesize resultView;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)dealloc
{
    [resultView release];
    [webView release];
    [super dealloc];
}

@end

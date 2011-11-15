//
//  ZTSearchResultViewCell.h
//  Search Text View
//
//  Created by Billy Gray on 11/14/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTSearchResultViewCell : UITableViewCell
{
    UIWebView *webView;
    UILabel *resultView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel *resultView;
@end

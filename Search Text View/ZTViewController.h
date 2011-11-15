//
//  ZTViewController.h
//  Search Text View
//
//  Created by Billy Gray on 11/14/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTSearchResultViewCell;

@interface ZTViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate> 
{
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    UITextView *textView;
    NSMutableArray *searchResults;
    ZTSearchResultViewCell *resultCell;
    
    // The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    BOOL			searchWasActive;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) IBOutlet ZTSearchResultViewCell *resultCell;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) BOOL searchWasActive;

@end

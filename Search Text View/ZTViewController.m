//
//  ZTViewController.m
//  Search Text View
//
//  Created by Billy Gray on 11/14/11.
//  Copyright (c) 2011 Zetetic LLC. All rights reserved.
//

#import "ZTViewController.h"
#import "ZTSearchResultViewCell.h"

#define kSEARCH_RESULT_LOCATION_KEY @"searchResultLocationKey"
#define kSEARCH_RESULT_CONTEXT_STRING_KEY @"searchResultContextStringKey"
#define kSEARCH_RESULT_CONTEXT_LOCATION_KEY @"searchResultContextLocationKey"
#define kSEARCH_RESULT_LOCATION_IN_CONTEXT_KEY @"searchResultLocationInContextKey"
#define CHAR_COUNT_PRECEDING_RESULT 16
#define CHAR_COUNT_FOLLOWING_RESULT 120

@interface ZTViewController (Private)
- (void)_filterResultsForSearchText:(NSString *)searchText;
@end

@implementation ZTViewController

@synthesize searchBar;
@synthesize searchDisplayController;
@synthesize textView;
@synthesize searchResults;
@synthesize savedSearchTerm, searchWasActive;
@synthesize resultCell;

//// static var to hold our HTML template for result cells 
//static NSString *searchResultCellHTML = nil;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create a list to hold search results
    self.searchResults = [NSMutableArray array];
    
    // load up a large document for our text view
    NSURL *textURL = [[NSBundle mainBundle] URLForResource:@"AronBadyOnAssange" withExtension:@"txt"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfURL:textURL encoding:NSUTF8StringEncoding error:&error];
    [self.textView setText: text];
    [text release];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
//    // make sure we scoop up our HTML template
//    if (!searchResultCellHTML)
//    {
//        NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"ZTSearchResultViewCell" withExtension:@"html"];
//        NSError *error;
//        searchResultCellHTML = [[NSString alloc] initWithContentsOfURL:htmlURL encoding:NSUTF8StringEncoding error:&error];
//        if (!searchResultCellHTML) {
//            NSLog(@"Error loading HTML: %@", error);
//            searchResultCellHTML = @"%@"; // helps prevent crash from string formatter
//        }
//    }
}

- (void)viewDidUnload
{
    // clear this, too
    self.searchResults = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.searchBar = nil;
    self.searchDisplayController = nil;
    self.textView = nil;
    self.resultCell = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc
{
    [resultCell release];
    [savedSearchTerm release];
    [searchResults release];
    [searchBar release];
    [searchDisplayController release];
    [textView release];
    [super dealloc];
}

#pragma mark - UITableView datasource, delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Our only table view is the one created by the search controller objects
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"SearchResultCellIdentifier";
	
	ZTSearchResultViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
        [[NSBundle mainBundle] loadNibNamed:@"ZTSearchResultViewCell" owner:self options:nil];
        cell = resultCell;
        self.resultCell = nil;
	}
    
    // search results will actually consist of a range indicating location of the found result in the main text body
    NSDictionary *dict = [self.searchResults objectAtIndex:indexPath.row];
    NSString *resultString = [[dict objectForKey:kSEARCH_RESULT_CONTEXT_STRING_KEY] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSString *html = [NSString stringWithFormat:searchResultCellHTML, resultString];
    //[cell.webView loadHTMLString:html baseURL:nil];
    cell.resultView.text = resultString;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *result = [self.searchResults objectAtIndex:indexPath.row];
    NSUInteger location = [[result objectForKey:kSEARCH_RESULT_CONTEXT_LOCATION_KEY] intValue];
    NSUInteger length = [[result objectForKey:kSEARCH_RESULT_CONTEXT_STRING_KEY] length];
    NSRange range = NSMakeRange(location, length);
    
    CGPoint offset = [self.textView contentOffset];
    NSLog(@"Y offset before scroll: %f", offset.y);
    
    // this, unfortunately, will scroll so that the text only just appears 
    // at the bottom of the screen, "visible", but not at the top as we'd like
    [self.textView scrollRangeToVisible: range];
    
    offset = [self.textView contentOffset];
    NSLog(@"Y offset after scroll: %f", offset.y);
    
    CGRect frame = [self.textView frame];
    CGPoint newOffset = CGPointMake(offset.x, frame.size.height - 20.0);
    [self.textView setContentOffset:newOffset animated:NO];
    
    offset = [self.textView contentOffset];
    NSLog(@"Y offset after adjustment: %f", offset.y);
    
    [searchDisplayController setActive:NO animated:NO];
}

#pragma mark - UISearchDisplayController Delegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"received request to search");
    // we need to squash searches until there's at least three characters to search on
    if ([searchString length] >= 3) 
    {
        [self _filterResultsForSearchText:searchString];
        // Return YES to cause the search result table view to be reloaded.
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Search implementation

- (void)_filterResultsForSearchText:(NSString *)searchText;
{
    NSLog(@"looking for instances of %@", searchText);
    // clear out any previous list of results
    [self.searchResults removeAllObjects];
    
    NSString *textDocument = [self.textView text];
    NSUInteger location = 0;
    NSUInteger length = [textDocument length];
    // initial search for the first range...
    NSRange range = [textDocument rangeOfString:searchText options:(NSCaseInsensitiveSearch)];
    while (range.location != NSNotFound) {
        location = range.location;
        // create a dictionary describing the search result: location in doc plus text around it for results display
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
//        // the location in the document where our term was found
//        [dict setObject:[NSNumber numberWithInt:range.location] forKey:kSEARCH_RESULT_LOCATION_KEY];
        
        // let's try to get a range on the text surrounding our found result while we're here
        NSInteger contextStart;
        if (location <= CHAR_COUNT_PRECEDING_RESULT) {
            contextStart = 0;
        } else {
            contextStart = location - CHAR_COUNT_PRECEDING_RESULT;
        }
        NSInteger contextLength = CHAR_COUNT_PRECEDING_RESULT + [searchText length] + CHAR_COUNT_FOLLOWING_RESULT;
        if (contextStart + contextLength > length) {
            contextLength = length - contextStart;
        }
        NSRange contextRange = NSMakeRange(contextStart, contextLength);
        NSLog(@"pulling substring with range %d,%d from textDocument with length %d", contextRange.location, contextRange.length, length);
        NSString *contextString = [textDocument substringWithRange:contextRange];
        [dict setObject:contextString forKey:kSEARCH_RESULT_CONTEXT_STRING_KEY];
        [dict setObject:[NSNumber numberWithInt:contextRange.location] forKey:kSEARCH_RESULT_CONTEXT_LOCATION_KEY];
//        [dict setObject:[NSNumber numberWithInt:CHAR_COUNT_PRECEDING_RESULT] forKey:kSEARCH_RESULT_LOCATION_IN_CONTEXT_KEY];
        
        NSLog(@"adding search result dict: %@", dict);
        [self.searchResults addObject: dict];
        [dict release];
        
        // update location for our while loop and creating the next range
        location = range.location + range.length;
        // set the new search range for the next pass
        NSRange searchRange = NSMakeRange(location, length - location);
        range = [textDocument rangeOfString:searchText options:(NSCaseInsensitiveSearch) range:searchRange];
    }
}

@end

//
//  crtFontListTableViewController.m
//  Font catalogue
//
//  Created by Alwin Chin on 14/08/13.
//  Copyright (c) 2013 creategroup. All rights reserved.
//

#import "crtFontListTableViewController.h"
#import "crtFontTableViewCell.h"
#import "crtFont.h"

@interface crtFontListTableViewController ()

@end

@implementation crtFontListTableViewController

@synthesize fontList;
@synthesize filteredFontList;
@synthesize displayFontList;
@synthesize fontSearchBar;
@synthesize fontTableView;
@synthesize isRefreshed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Create";
  
    // Don't show the scope bar or cancel button until editing begins
    fontSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    fontSearchBar.delegate = self;
    self.tableView.tableHeaderView = fontSearchBar;
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:fontSearchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.delegate = self;
    [fontSearchBar sizeToFit];
  
    // Hide the search bar until user scrolls up
    [self.fontTableView setDelegate:self];
    [self.fontTableView setDataSource:self];
    [self.fontTableView setBackgroundColor:[UIColor whiteColor]];
  
    fontList = [[NSMutableArray alloc] init];
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
      fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
      for (indFont=0; indFont<[fontNames count]; ++indFont)
      {
        NSString *fontName = [fontNames objectAtIndex:indFont];
        NSLog(@"    Font name: %@", fontName);
        [fontList addObject:[crtFont fontWithNameRating:fontName rating:0]];
      }
    }
  
    // Initialize the filtered list with a capacity
    filteredFontList = [NSMutableArray arrayWithCapacity:[fontList count]];
    [self.filteredFontList removeAllObjects];
    [self.filteredFontList addObjectsFromArray:[self fontList]];
  
    // Initialise the display list
    self.isRefreshed = NO; // reset state
    displayFontList = [NSMutableArray arrayWithCapacity:[fontList count]];
    [self.displayFontList addObjectsFromArray:[self sortByAlpha:self.filteredFontList]];
  
    [self.tableView addSubview:fontTableView];
    // Reload the table
    [[self fontTableView] reloadData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (!self.isRefreshed) {
    return [[self filteredFontList] count];
  }
  else {
    return [[self fontList] count];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    crtFontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if ( cell == nil ) {
      cell = [[crtFontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    // Create a new Font Object
    crtFont *aFont = nil;
  
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
      aFont = [displayFontList objectAtIndex:[indexPath row]];
    } else if (!self.isRefreshed) {
      aFont = [displayFontList objectAtIndex:[indexPath row]];
    } else {
      aFont = [fontList objectAtIndex:[indexPath row]];
    }
  
    // Configure the cell
    [[cell textLabel] setText:[aFont fontName]];
    CGRect labelRect = CGRectMake(10, 50, 300, 50);
    NSString *fontNameStr = [aFont fontName];
    CGFloat fontSize = 30;
    while (fontSize > 0.0)
    {
      CGSize size = [fontNameStr sizeWithFont:[UIFont fontWithName:[aFont fontName] size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
    
      if (size.height <= labelRect.size.height) break;
    
      fontSize -= 1.0;
    }
  
    [[cell textLabel] setFont:[UIFont fontWithName:[aFont fontName] size:fontSize]];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
  // Remove all objects from the filtered search array
	[self.filteredFontList removeAllObjects];
  
	// Filter the array using NSPredicate
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
  NSArray *tempArray = [fontList filteredArrayUsingPredicate:predicate];
  
  if(![scope isEqualToString:@"All"]) {
    // Further filter the array with the scope
    NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
    tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
  }
  
  filteredFontList = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  // Tells the table data source to reload when text changes
  [self filterContentForSearchText:searchString scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
  // Tells the table data source to reload when scope bar selection changes
  [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
   [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}

#pragma mark - Search Button

- (IBAction)goToSearch:(id)sender
{
  // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
  // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
  [fontSearchBar becomeFirstResponder];
}





#pragma mark - Sort Alpha BLOCK method
- (NSArray*) sortByAlpha:(NSMutableArray *) listTosort
{
  NSArray *sortedArray;
  sortedArray = [listTosort sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    crtFont *first = (crtFont*)a;
    crtFont *second = (crtFont*)b;
    
    NSString *firstFont = first.fontName;
    NSString *secondFont = second.fontName;
    
    return [firstFont compare:secondFont];
  }];
  return sortedArray;
}


#pragma mark - Sort byFontSize
- (NSArray*) sortByFontLength:(NSMutableArray *) listToSort
{
  NSArray *sortedArray;
  sortedArray = [listToSort sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    crtFont *first = (crtFont*)a;
    crtFont *second = (crtFont*)b;
    
    int firstLength = [first.fontName length];
    int secondLength = [second.fontName length];
    
    return firstLength >= secondLength;
  }];
  return sortedArray;
}

#pragma mark - Reverse List
- (NSArray*) reverseList:(NSMutableArray *) listToReverse
{
  return [[listToReverse reverseObjectEnumerator] allObjects];
}


@end
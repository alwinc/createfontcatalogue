//
//  crtFontListTableViewController.h
//  Font catalogue
//
//  Created by Alwin Chin on 14/08/13.
//  Copyright (c) 2013 creategroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface crtFontListTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong,nonatomic) NSMutableArray *fontList;
@property (strong,nonatomic) NSMutableArray *filteredFontList;
@property (strong,nonatomic) NSMutableArray *displayFontList;
@property IBOutlet UISearchBar *fontSearchBar;
@property (nonatomic,retain) UITableView *fontTableView;
@property (nonatomic,assign) BOOL isRefreshed;

@end

//
//  AssetTypeViewController.h
//  WineTastingJournal
//
//  Created by David Westgate on 6/22/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Item;

@interface AssetTypeViewController : UITableViewController

@property (nonatomic, strong) Item *item;

@end

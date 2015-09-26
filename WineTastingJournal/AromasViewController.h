//
//  AromasViewController.h
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Item;

@interface AromasViewController : UITableViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *tastes;
@property (nonatomic, strong) NSArray *characteristics;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableOrderedSet *selectedCharacteristics;
@property (nonatomic, strong) NSMutableDictionary *selectedAromas;

@end

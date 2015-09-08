//
//  DetailViewController.h
//  WineTastingJournal
//
//  Created by David Westgate on 6/17/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface DetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) Item *item;

@end

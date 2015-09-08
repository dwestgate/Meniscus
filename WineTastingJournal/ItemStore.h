//
//  ItemStore.h
//  WineTastingJournal
//
//  Created by David Westgate on 6/15/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+ (instancetype)sharedStore;
- (Item *)createItem;
- (void)removeItem:(Item *)item;
- (void)moveItemAtIndex:(NSUInteger) fromIndex
                toIndex:(NSUInteger) toIndex;
- (BOOL)saveChanges;
- (NSArray *)allAssetTypes;
- (NSArray *)allAromas;

@end

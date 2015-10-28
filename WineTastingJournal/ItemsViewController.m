//
//  ItemsViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/15/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "DetailViewController.h"
#import "ItemCell.h"
#import "ImageStore.h"
#import "ImageViewController.h"

@interface ItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

// @property (strong, nonatomic) UIPopoverController *imagePopover;
// @property (strong, nonatomic) UIPopoverPresentationController *imagePopover;

@end

@implementation ItemsViewController

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
  return [[self alloc] init];
}

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
      UINavigationItem *navItem = self.navigationItem;
      navItem.title = NSLocalizedString(@"Meniscus", @"Name of application");
      
      self.restorationIdentifier = NSStringFromClass([self class]);
      self.restorationClass = [self class];
      
      UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];

      navItem.rightBarButtonItem = bbi;
      navItem.leftBarButtonItem = self.editButtonItem;
      
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self
             selector:@selector(updateTableViewForDynamicTypeSize)
                 name:UIContentSizeCategoryDidChangeNotification
               object:nil];
      [nc addObserver:self
             selector:@selector(localeChanged:)
                 name:NSCurrentLocaleDidChangeNotification
               object:nil];
    }
    return self;
}

- (void)dealloc
{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStylePlain];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
  
  NSArray *items = [[ItemStore sharedStore] allItems];
  Item *item = items[indexPath.row];
  
  cell.noteTitleLabel.text = item.itemNoteTitle;
  cell.thumbnailView.image = item.thumbnail;
  
  __weak ItemCell *weakCell = cell;
  
  cell.actionBlock = ^{NSLog(@"SHowing image for %@", item);
    
    ItemCell *strongCell = weakCell;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      NSString *itemKey = item.itemKey;
      
      UIImage *img = [[ImageStore sharedStore] imageForKey:itemKey];
      if (!img) {
        return;
      }
      CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
      
      ImageViewController *ivc = [[ImageViewController alloc] init];
      ivc.image = img;
      
      ivc.modalPresentationStyle = UIModalPresentationPopover;
      [self presentViewController:ivc animated:YES completion:nil];
      
      UIPopoverPresentationController *imagePopover = [ivc popoverPresentationController];
      
      imagePopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
      imagePopover.sourceView = self.view;
      imagePopover.sourceRect = rect;
      
      /*
       self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
       self.imagePopover.delegate = self;
       self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
       [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
       */
    }
  };
  
  return cell;
}

/*
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}
*/

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
  
  self.tableView.restorationIdentifier = @"ItemsViewControllerTableView";
}

- (void)viewDidAppear:(BOOL)animated {
  if ([[[ItemStore sharedStore] allItems] count] < 1) {
    [self showWelcomeMessage];
  }
  [super viewDidAppear:animated];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
  [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];
  
  [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
  self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
  
  [super decodeRestorableStateWithCoder:coder];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)path inView:(UIView *)view
{
  NSString *identifier = nil;
  
  if (path && view) {
    Item *item = [[ItemStore sharedStore] allItems][path.row];
    identifier = item.itemKey;
  }
  
  return identifier;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
  NSIndexPath *indexPath = nil;
  
  if (identifier && view) {
    NSArray *items = [[ItemStore sharedStore] allItems];
    for (Item *item in items) {
      if ([identifier isEqualToString:item.itemKey]) {
        int row = (int)[items indexOfObjectIdenticalTo:item];
        indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        break;
      }
    }
  }
  return indexPath;
}

- (IBAction)addNewItem:(id)sender
{
  Item *newItem = [[ItemStore sharedStore] createItem];
    
  DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
  detailViewController.item = newItem;
  detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
  navController.restorationIdentifier = NSStringFromClass([navController class]);
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
  [self presentViewController:navController animated:YES completion:NULL];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[ItemStore sharedStore] allItems];
        Item *item = items[indexPath.row];
        [[ItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];

    NSArray *items = [[ItemStore sharedStore] allItems];
    Item *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                UIContentSizeCategorySmall : @44,
                                UIContentSizeCategoryMedium : @44,
                                UIContentSizeCategoryLarge : @44,
                                UIContentSizeCategoryExtraLarge : @55,
                                UIContentSizeCategoryExtraExtraLarge : @65,
                                UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

#pragma mark - I18n L10n

- (void)localeChanged:(NSNotification *)note
{
  [self.tableView reloadData];
}

#pragma mark - Helper methods

- (void)showWelcomeMessage {
  UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Meniscus" message:@"Add new tasting notes\nwith the + button.\n\nAccess help while\n creating notes via\nthe ⓘ button" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [ac dismissViewControllerAnimated:YES completion:nil];
  }];
  [ac addAction:okButton];
  
  UIViewController *rootViewController=[UIApplication sharedApplication].delegate.window.rootViewController;
  [rootViewController presentViewController:ac animated:YES completion:nil];
}

@end

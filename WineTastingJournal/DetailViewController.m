//
//  DetailViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/17/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "AssetTypeViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (weak, nonatomic) IBOutlet UILabel *appearanceBanner;

@property (weak, nonatomic) IBOutlet UILabel *clarityLabel;
@property (weak, nonatomic) IBOutlet UISlider *claritySlider;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;

@property (weak, nonatomic) IBOutlet UILabel *colorIntensityLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorIntensity;
@property (weak, nonatomic) IBOutlet UIStepper *colorIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *colorShadeLabel;
@property (weak, nonatomic) IBOutlet UISlider *colorShadeSlider;

@property (weak, nonatomic) IBOutlet UILabel *petillanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *petillance;
@property (weak, nonatomic) IBOutlet UIStepper *petillanceStepper;

@property (weak, nonatomic) IBOutlet UILabel *viscosityLabel;
@property (weak, nonatomic) IBOutlet UILabel *viscosity;
@property (weak, nonatomic) IBOutlet UIStepper *viscosityStepper;

@property (weak, nonatomic) IBOutlet UILabel *sedimentLabel;
@property (weak, nonatomic) IBOutlet UISlider *sedimentSlider;

@property (weak, nonatomic) IBOutlet UILabel *noseBanner;

@property (weak, nonatomic) IBOutlet UILabel *aromaIntensityLabel;
@property (weak, nonatomic) IBOutlet UILabel *aromaIntensity;
@property (weak, nonatomic) IBOutlet UIStepper *aromaIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *aromasLabel;
@property (weak, nonatomic) IBOutlet UITextView *aromasTextView;

@property (weak, nonatomic) IBOutlet UILabel *developmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *development;
@property (weak, nonatomic) IBOutlet UIStepper *developmentStepper;

@property (weak, nonatomic) IBOutlet UILabel *palateBanner;

@property (weak, nonatomic) IBOutlet UILabel *sweetnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *sweetness;
@property (weak, nonatomic) IBOutlet UIStepper *sweetnessStepper;

@property (weak, nonatomic) IBOutlet UILabel *acidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *acidity;
@property (weak, nonatomic) IBOutlet UIStepper *acidityStepper;

@property (weak, nonatomic) IBOutlet UILabel *tanninLabel;
@property (weak, nonatomic) IBOutlet UILabel *tannin;
@property (weak, nonatomic) IBOutlet UIStepper *tanninStepper;

@property (weak, nonatomic) IBOutlet UILabel *alchoholLabel;
@property (weak, nonatomic) IBOutlet UILabel *alchohol;
@property (weak, nonatomic) IBOutlet UIStepper *alchoholStepper;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIStepper *bodyStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorIntensityLabel;
@property (weak, nonatomic) IBOutlet UILabel *flavorIntensity;
@property (weak, nonatomic) IBOutlet UIStepper *flavorIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *flavorsTextView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *balanceSlider;

@property (weak, nonatomic) IBOutlet UILabel *mousseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mousse;
@property (weak, nonatomic) IBOutlet UIStepper *mousseStepper;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *finish;
@property (weak, nonatomic) IBOutlet UIStepper *finishStepper;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UISlider *qualitySlider;

@property (weak, nonatomic) IBOutlet UIPickerView *agingPicker;

@property (weak, nonatomic) IBOutlet UILabel *detailsBanner;

@property (weak, nonatomic) IBOutlet UILabel *winemakerLabel;
@property (weak, nonatomic) IBOutlet UITextField *winemakerTextField;

@property (weak, nonatomic) IBOutlet UILabel *vintageLabel;
@property (weak, nonatomic) IBOutlet UITextField *vintageTextField;

@property (weak, nonatomic) IBOutlet UILabel *appellationLabel;
@property (weak, nonatomic) IBOutlet UITextField *appellationTextField;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UILabel *tastedOnBanner;

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

@end

@implementation DetailViewController

#pragma mark - State Recovery

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path coder:(NSCoder *)coder
{
  BOOL isNew = NO;
  if ([path count] == 3) {
    isNew = YES;
  }
  
  return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.item.itemKey
               forKey:@"item.itemKey"];
  
  self.item.itemName = self.nameTextView.text;
  self.item.vintage = self.vintageTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  
  [[ItemStore sharedStore] saveChanges];
  
  [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
  NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
  for (Item *item in [[ItemStore sharedStore] allItems]) {
    if ([itemKey isEqualToString:item.itemKey]) {
      self.item = item;
      break;
    }
  }
  
  [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - Initializers

- (instancetype)initForNewItem:(BOOL)isNew
{
  self = [super initWithNibName:nil bundle:nil];
    
  if (self) {
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];
      
    if (isNew) {
      UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
      self.navigationItem.rightBarButtonItem = doneItem;
      UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
      self.navigationItem.leftBarButtonItem = cancelItem;
    }
        
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
    
  return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong initializer"
                format:@"Use initForNewItem:"];
    return nil;
}

#pragma mark - Control Actions

- (IBAction)claritySliderValueChanged:(id)sender {
  if (_claritySlider.value < .25) {
    _claritySlider.value = 0;
    _clarityLabel.text = @"Clear";
  } else if ((_claritySlider.value >= .25) && (_claritySlider.value < .75)) {
    _claritySlider.value = .50;
    _clarityLabel.text = @"Hazy";
  } else {
    _claritySlider.value = 1;
    _clarityLabel.text = @"Faulty";
  }
}

- (IBAction)colorSliderValueChanged:(id)sender {
  if (_colorSlider.value < .25) {
    _colorSlider.value = 0;
    _colorLabel.text = @"White";
  } else if ((_colorSlider.value >= .25) && (_colorSlider.value < .75)) {
    _colorSlider.value = .50;
    _colorLabel.text = @"Rosé";
  } else {
    _colorSlider.value = 1;
    _colorLabel.text = @"Red";
  }
  [self colorShadeSliderValueChanged:nil];
}

- (IBAction)colorShadeSliderValueChanged:(id)sender {
  
  if (_colorSlider.value == 0) {
    if (_colorShadeSlider.value < .16) {
      _colorShadeSlider.value = 0;
      _colorShadeLabel.text = @"Lemon-green";
    } else if ((_colorShadeSlider.value >= .17) && (_colorShadeSlider.value < .50)) {
      _colorShadeSlider.value = .33;
      _colorShadeLabel.text = @"Lemon";
    } else if ((_colorShadeSlider.value >= .51) && (_colorShadeSlider.value < .83)) {
      _colorShadeSlider.value = .66;
      _colorShadeLabel.text = @"Gold";
    } else {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Amber";
    }
  } else if (_colorSlider.value == .50) {
    if (_colorShadeSlider.value < .25) {
      _colorShadeSlider.value = 0;
      _colorShadeLabel.text = @"Pink";
    } else if ((_colorShadeSlider.value >= .25) && (_colorShadeSlider.value < .75)) {
      _colorShadeSlider.value = .50;
      _colorShadeLabel.text = @"Salmon";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Orange";
    }
  } else {
    if (_colorShadeSlider.value < .16) {
      _colorShadeSlider.value = 0;
      _colorShadeLabel.text = @"Purple";
    } else if ((_colorShadeSlider.value >= .17) && (_colorShadeSlider.value < .50)) {
      _colorShadeSlider.value = .33;
      _colorShadeLabel.text = @"Ruby";
    } else if ((_colorShadeSlider.value >= .51) && (_colorShadeSlider.value < .83)) {
      _colorShadeSlider.value = .66;
      _colorShadeLabel.text = @"Garnet";
    } else {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Tawny";
    }
  }

}

- (IBAction)showAssetTypePicker:(id)sender {
  [self.view endEditing:YES];
  
  AssetTypeViewController *avc = [[AssetTypeViewController alloc] init];
  avc.item = self.item;
  
  [self.navigationController pushViewController:avc
                                       animated:YES];
}

#pragma mark - ImagePicker

- (void)cancel:(id)sender
{
    [[ItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    [[ImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    self.imageView.image = image;
    
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - View Constraints

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}


- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.scrollView layoutIfNeeded];
  self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:iv];
    self.imageView = iv;
  
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
  
    NSDictionary *nameMap = @{@"imageView" : self.imageView, @"tastedOnBanner" : self.tastedOnBanner};
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tastedOnBanner]-[imageView]-0-|" options:0 metrics:nil views:nameMap];
  
    [self.contentView addConstraints:horizontalConstraints];
    [self.contentView addConstraints:verticalConstraints];
}

#pragma mark - Form Maintenance

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.vintageLabel.font = font;
    self.tastedOnBanner.font = font;
    self.nameTextView.font = font;
    self.vintageTextField.font = font;
    self.priceTextField.font = font;
}

- (void)setItem:(Item *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    Item *item = self.item;
    
    self.nameTextView.text = item.itemName;
    self.vintageTextField.text = item.vintage;
    self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.tastedOnBanner.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:itemKey];
    self.imageView.image = imageToDisplay;
  
  NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
  if (!typeLabel) {
    typeLabel = NSLocalizedString(@"None", @"Type label None");
  }
  
  self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
  
    [self updateFonts];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
    
  [self.view endEditing:YES];
    
  Item *item = self.item;
  item.itemName = self.nameTextView.text;
  item.vintage = self.vintageTextField.text;
  
  int newValue = [self.priceTextField.text intValue];
  
  if (newValue != item.valueInDollars) {
    item.valueInDollars = newValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:newValue forKey:NextItemValuePrefsKey];
  }
}

@end

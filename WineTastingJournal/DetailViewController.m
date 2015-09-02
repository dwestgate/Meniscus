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

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UISlider *conditionSlider;

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
@property (weak, nonatomic) IBOutlet UITextField *balanceTextField;

@property (weak, nonatomic) IBOutlet UILabel *mousseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mousse;
@property (weak, nonatomic) IBOutlet UIStepper *mousseStepper;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *finish;
@property (weak, nonatomic) IBOutlet UIStepper *finishStepper;

@property (weak, nonatomic) IBOutlet UILabel *conclusionsBanner;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UISlider *qualitySlider;

@property (weak, nonatomic) IBOutlet UILabel *readinessLabel;
@property (weak, nonatomic) IBOutlet UITextField *readinessTextField;

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
  self.item.itemNotes = self.notesTextView.text;
  self.item.itemClarity = self.clarityLabel.text;
  self.item.itemClarityValue = self.claritySlider.value;
  self.item.itemColor = self.colorLabel.text;
  self.item.itemColorValue = self.colorSlider.value;
  self.item.itemColorIntensity = self.colorIntensity.text;
  self.item.itemColorIntensityValue = self.colorIntensityStepper.value;
  self.item.itemColorShade = self.colorShadeLabel.text;
  self.item.itemColorShadeValue = self.colorShadeSlider.value;
  self.item.itemPetillance = self.petillance.text;
  self.item.itemPetillanceValue = self.petillanceStepper.value;
  self.item.itemViscosity = self.viscosity.text;
  self.item.itemViscosityValue = self.viscosityStepper.value;
  self.item.itemSediment = self.sedimentLabel.text;
  self.item.itemSedimentValue = self.sedimentSlider.value;
  self.item.itemCondition = self.conditionLabel.text;
  self.item.itemConditionSliderValue = self.conditionSlider.value;
  self.item.itemAromaIntensity = self.aromaIntensity.text;
  self.item.itemAromaIntensityValue = self.aromaIntensityStepper.value;
  self.item.itemAromas = self.aromasTextView.text;
  self.item.itemDevelopment = self.development.text;
  self.item.itemDevelopmentValue = self.developmentStepper.value;
  self.item.itemSweetness = self.sweetness.text;
  self.item.itemSweetnessValue = self.sweetnessStepper.value;
  self.item.itemAcidity = self.acidity.text;
  self.item.itemAcidityValue = self.acidityStepper.value;
  self.item.itemTannin = self.tannin.text;
  self.item.itemTanninValue = self.tanninStepper.value;
  self.item.itemAlchohol = self.alchohol.text;
  self.item.itemAlchoholValue = self.alchoholStepper.value;
  self.item.itemBody = self.body.text;
  self.item.itemBodyValue = self.bodyStepper.value;
  self.item.itemFlavorIntensity = self.flavorIntensity.text;
  self.item.itemFlavorIntensityValue = self.flavorIntensityStepper.value;
  self.item.itemFlavors = self.flavorsTextView.text;
  self.item.itemBalance = self.balanceTextField.text;
  self.item.itemMousse = self.mousse.text;
  self.item.itemMousseValue = self.mousseStepper.value;
  self.item.itemFinish = self.finish.text;
  self.item.itemFinishValue = self.finishStepper.value;
  self.item.itemQuality = self.qualityLabel.text;
  self.item.itemQualityValue = self.qualitySlider.value;
  self.item.itemReadiness = self.readinessTextField.text;
  self.item.itemWinemaker = self.winemakerTextField.text;
  self.item.itemVintage = self.vintageTextField.text;
  self.item.itemAppellation = self.appellationTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  /*
  self.item.itemName = self.nameTextView.text;
  self.item.vintage = self.vintageTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  */
  
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
  if (_claritySlider.value < 25) {
    _claritySlider.value = 1;
    _clarityLabel.text = @"Clear";
  } else if ((_claritySlider.value >= 25) && (_claritySlider.value < 75)) {
    _claritySlider.value = 50;
    _clarityLabel.text = @"Hazy";
  } else {
    _claritySlider.value = 100;
    _clarityLabel.text = @"Faulty";
  }
}

- (IBAction)colorSliderValueChanged:(id)sender {
  if (_colorSlider.value < 25) {
    _colorSlider.value = 1;
    _colorLabel.text = @"White";
  } else if ((_colorSlider.value >= 25) && (_colorSlider.value < 75)) {
    _colorSlider.value = 50;
    _colorLabel.text = @"Rosé";
  } else {
    _colorSlider.value = 100;
    _colorLabel.text = @"Red";
  }
  [self colorShadeSliderValueChanged:nil];
  [self colorShadeSliderValueChanged:nil];
}

- (IBAction)colorIntensityValueChanged:(id)sender {
  
  if (_colorIntensityStepper.value == 1) {
    
    if (_colorSlider.value == 50) {
      _colorIntensity.text = @"Light";
    } else {
      _colorIntensity.text = @"Pale";
    }
    
  } else if (_colorIntensityStepper.value == 2) {
    _colorIntensity.text = @"Medium";
  } else {
    _colorIntensity.text = @"Deep";
  }
}

- (IBAction)colorShadeSliderValueChanged:(id)sender {
  if (_colorSlider.value == 1) {
    if (_colorShadeSlider.value < 16) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Lemon-green";
    } else if ((_colorShadeSlider.value >= 16) && (_colorShadeSlider.value < 50)) {
      _colorShadeSlider.value = 33;
      _colorShadeLabel.text = @"Lemon";
    } else if ((_colorShadeSlider.value >= 50) && (_colorShadeSlider.value < 83)) {
      _colorShadeSlider.value = 66;
      _colorShadeLabel.text = @"Gold";
    } else {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Amber";
    }
  } else if (_colorSlider.value == 50) {
    if (_colorShadeSlider.value < 25) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Pink";
    } else if ((_colorShadeSlider.value >= 25) && (_colorShadeSlider.value < 75)) {
      _colorShadeSlider.value = 50;
      _colorShadeLabel.text = @"Salmon";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Orange";
    }
  } else {
    if (_colorShadeSlider.value < 16) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Purple";
    } else if ((_colorShadeSlider.value >= 16) && (_colorShadeSlider.value < 50)) {
      _colorShadeSlider.value = 33;
      _colorShadeLabel.text = @"Ruby";
    } else if ((_colorShadeSlider.value >= 50) && (_colorShadeSlider.value < 83)) {
      _colorShadeSlider.value = 66;
      _colorShadeLabel.text = @"Garnet";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Tawny";
    }
  }
}

- (IBAction)petillanceValueChanged:(id)sender {
  
  if (_petillanceStepper.value == 1) {
    _petillance.text = @"None";
  } else if (_petillanceStepper.value == 2) {
    _petillance.text = @"Light";
  } else {
    _petillance.text = @"Pronounced";
  }
}

- (IBAction)viscosityValueChanged:(id)sender {
  
  if (_viscosityStepper.value == 1) {
    _viscosity.text = @"Clear legs";
  } else if (_viscosityStepper.value == 2) {
    _viscosity.text = @"Stained legs";
  } else {
    _viscosity.text = @"Sheeting";
  }
}

- (IBAction)sedimentSliderValueChanged:(id)sender {
  if (_sedimentSlider.value < 16) {
    _sedimentSlider.value = 1;
    _sedimentLabel.text = @"No sediment";
  } else if ((_sedimentSlider.value >= 16) && (_sedimentSlider.value < 50)) {
    _sedimentSlider.value = 33;
    _sedimentLabel.text = @"Fine sediment";
  } else if ((_sedimentSlider.value >= 50) && (_sedimentSlider.value < 83)) {
    _sedimentSlider.value = 66;
    _sedimentLabel.text = @"Crystals";
  } else {
    _sedimentSlider.value = 100;
    _sedimentLabel.text = @"Heavy deposits";
  }
}

- (IBAction)conditionSliderValueChanged:(id)sender {
  if (_conditionSlider.value < 25) {
    _conditionSlider.value = 1;
    _conditionLabel.text = @"Clean";
  } else if ((_conditionSlider.value >= 25) && (_conditionSlider.value < 75)) {
    _conditionSlider.value = 50;
    _conditionLabel.text = @"Unclean";
  } else {
    _conditionSlider.value = 100;
    _conditionLabel.text = @"Corked";
  }
}

- (IBAction)aromaIntensityValueChanged:(id)sender {
  if (_aromaIntensityStepper.value == 1) {
    _aromaIntensity.text = @"Light";
  } else if (_aromaIntensityStepper.value == 2) {
    _aromaIntensity.text = @"Medium -";
  } else if (_aromaIntensityStepper.value == 3) {
    _aromaIntensity.text = @"Medium";
  } else if (_aromaIntensityStepper.value == 4) {
    _aromaIntensity.text = @"Medium +";
  } else {
    _aromaIntensity.text = @"Pronounced";
  }
}

- (IBAction)developmentValueChanged:(id)sender {
  
  if (_developmentStepper.value == 1) {
    _development.text = @"Youthful";
  } else if (_developmentStepper.value == 2) {
    _development.text = @"Developing";
  } else if (_developmentStepper.value == 3) {
    _development.text = @"Fully developed";
  } else {
    _development.text = @"Tired/Past prime";
  }
}

- (IBAction)sweetnessValueChanged:(id)sender {
  
  if (_sweetnessStepper.value == 1) {
    _sweetness.text = @"Dry";
  } else if (_sweetnessStepper.value == 2) {
    _sweetness.text = @"Off-dry";
  } else if (_sweetnessStepper.value == 3) {
    _sweetness.text = @"Medium -dry";
  } else if (_sweetnessStepper.value == 4) {
    _sweetness.text = @"Medium -sweet";
  } else if (_sweetnessStepper.value == 5) {
    _sweetness.text = @"Sweet";
  } else {
    _sweetness.text = @"Luscious";
  }
}

- (IBAction)acidityValueChanged:(id)sender {
  if (_acidityStepper.value == 1) {
    _acidity.text = @"Low";
  } else if (_acidityStepper.value == 2) {
    _acidity.text = @"Medium -";
  } else if (_acidityStepper.value == 3) {
    _acidity.text = @"Medium";
  } else if (_acidityStepper.value == 4) {
    _acidity.text = @"Medium +";
  } else {
    _acidity.text = @"High";
  }
}

- (IBAction)tanninValueChanged:(id)sender {
  if (_tanninStepper.value == 1) {
    _tannin.text = @"Low";
  } else if (_tanninStepper.value == 2) {
    _tannin.text = @"Medium -";
  } else if (_tanninStepper.value == 3) {
    _tannin.text = @"Medium";
  } else if (_tanninStepper.value == 4) {
    _tannin.text = @"Medium +";
  } else {
    _tannin.text = @"High";
  }
}

- (IBAction)alchoholValueChanged:(id)sender {
  if (_alchoholStepper.value == 1) {
    _alchohol.text = @"Low (<11.5>";
  } else if (_alchoholStepper.value == 2) {
    _alchohol.text = @"Medium - (<12.5)";
  } else if (_alchoholStepper.value == 3) {
    _alchohol.text = @"Medium (<13.5)";
  } else if (_alchoholStepper.value == 4) {
    _alchohol.text = @"Medium + (<13.9)";
  } else {
    _alchohol.text = @"High (14+)";
  }
}

- (IBAction)bodyValueChanged:(id)sender {
  if (_bodyStepper.value == 1) {
    _body.text = @"Light";
  } else if (_bodyStepper.value == 2) {
    _body.text = @"Medium -";
  } else if (_bodyStepper.value == 3) {
    _body.text = @"Medium";
  } else if (_bodyStepper.value == 4) {
    _body.text = @"Medium +";
  } else {
    _body.text = @"Full";
  }
}

- (IBAction)flavorIntensityValueChanged:(id)sender {
  if (_flavorIntensityStepper.value == 1) {
    _flavorIntensity.text = @"Light";
  } else if (_flavorIntensityStepper.value == 2) {
    _flavorIntensity.text = @"Medium -";
  } else if (_flavorIntensityStepper.value == 3) {
    _flavorIntensity.text = @"Medium";
  } else if (_flavorIntensityStepper.value == 4) {
    _flavorIntensity.text = @"Medium +";
  } else {
    _flavorIntensity.text = @"Pronounced";
  }
}

- (IBAction)mousseValueChanged:(id)sender {
  if (_mousseStepper.value == 1) {
    _mousse.text = @"No mousse";
  } else if (_mousseStepper.value == 2) {
    _mousse.text = @"Delicate";
  } else if (_mousseStepper.value == 3) {
    _mousse.text = @"Creamy";
  } else {
    _mousse.text = @"Aggressive";
  }
}

- (IBAction)finishValueChanged:(id)sender {
  if (_finishStepper.value == 1) {
    _finish.text = @"Short";
  } else if (_finishStepper.value == 2) {
    _finish.text = @"Medium -";
  } else if (_finishStepper.value == 3) {
    _finish.text = @"Medium";
  } else if (_finishStepper.value == 4) {
    _finish.text = @"Medium +";
  } else {
    _finish.text = @"Long";
  }
}

- (IBAction)qualitySliderValueChanged:(id)sender {
  if (_qualitySlider.value < 10) {
    _qualitySlider.value = 1;
    _qualityLabel.text = @"Faulty";
  } else if ((_qualitySlider.value >= 10) && (_qualitySlider.value < 30)) {
    _qualitySlider.value = 20;
    _qualityLabel.text = @"Poor";
  } else if ((_qualitySlider.value >= 30) && (_qualitySlider.value < 50)) {
    _qualitySlider.value = 40;
    _qualityLabel.text = @"Acceptable";
  } else if ((_qualitySlider.value >= 50) && (_qualitySlider.value < 70)) {
    _qualitySlider.value = 60;
    _qualityLabel.text = @"Good quality";
  } else if ((_qualitySlider.value >= 70) && (_qualitySlider.value < 90)) {
    _qualitySlider.value = 80;
    _qualityLabel.text = @"Very good";
  } else {
    _qualitySlider.value = 100;
    _qualityLabel.text = @"Outstanding";
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
  
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
  
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
  self.nameTextView.font = font;
  self.notesLabel.font = font;
  self.notesTextView.font = font;
  self.appearanceBanner.font = font;
  self.clarityLabel.font = font;
  self.colorLabel.font = font;
  self.colorIntensityLabel.font = font;
  self.colorIntensity.font = font;
  self.colorShadeLabel.font = font;
  self.petillanceLabel.font = font;
  self.petillance.font = font;
  self.viscosityLabel.font = font;
  self.viscosity.font = font;
  self.sedimentLabel.font = font;
  self.noseBanner.font = font;
  self.conditionLabel.font = font;
  self.aromaIntensityLabel.font = font;
  self.aromaIntensity.font = font;
  self.aromasLabel.font = font;
  self.aromasTextView.font = font;
  self.developmentLabel.font = font;
  self.development.font = font;
  self.palateBanner.font = font;
  self.sweetnessLabel.font = font;
  self.sweetness.font = font;
  self.acidityLabel.font = font;
  self.acidity.font = font;
  self.tanninLabel.font = font;
  self.tannin.font = font;
  self.alchoholLabel.font = font;
  self.alchohol.font = font;
  self.bodyLabel.font = font;
  self.body.font = font;
  self.flavorIntensityLabel.font = font;
  self.flavorIntensity.font = font;
  self.flavorsLabel.font = font;
  self.flavorsTextView.font = font;
  self.balanceLabel.font = font;
  self.balanceTextField.font = font;
  self.mousseLabel.font = font;
  self.mousse.font = font;
  self.finishLabel.font = font;
  self.finish.font = font;
  self.conclusionsBanner.font = font;
  self.qualityLabel.font = font;
  self.readinessLabel.font = font;
  self.readinessTextField.font = font;
  self.detailsBanner.font = font;
  self.winemakerLabel.font = font;
  self.winemakerTextField.font = font;
  self.vintageLabel.font = font;
  self.vintageTextField.font = font;
  self.appellationLabel.font = font;
  self.appellationTextField.font = font;
  self.priceLabel.font = font;
  self.priceTextField.font = font;
  self.tastedOnBanner.font = font;
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
  self.notesTextView.text = item.itemNotes;
  self.clarityLabel.text = item.itemClarity;
  self.claritySlider.value = item.itemClarityValue;
  self.colorLabel.text = item.itemColor;
  self.colorSlider.value = item.itemColorValue;
  self.colorIntensity.text = item.itemColorIntensity;
  self.colorIntensityStepper.value = item.itemColorIntensityValue;
  self.colorShadeLabel.text = item.itemColorShade;
  self.colorShadeSlider.value = item.itemColorShadeValue;
  self.petillance.text = item.itemPetillance;
  self.petillanceStepper.value = item.itemPetillanceValue;
  self.viscosity.text = item.itemViscosity;
  self.viscosityStepper.value = item.itemViscosityValue;
  self.sedimentLabel.text = item.itemSediment;
  self.sedimentSlider.value = item.itemSedimentValue;
  self.conditionLabel.text = item.itemCondition;
  self.conditionSlider.value = item.itemConditionSliderValue;
  self.aromaIntensity.text = item.itemAromaIntensity;
  self.aromaIntensityStepper.value = item.itemAromaIntensityValue;
  self.aromasTextView.text = item.itemAromas;
  self.development.text = item.itemDevelopment;
  self.developmentStepper.value = item.itemDevelopmentValue;
  self.sweetness.text = item.itemSweetness;
  self.sweetnessStepper.value = item.itemSweetnessValue;
  self.acidity.text = item.itemAcidity;
  self.acidityStepper.value = item.itemAcidityValue;
  self.tannin.text = item.itemTannin;
  self.tanninStepper.value = item.itemTanninValue;
  self.alchohol.text = item.itemAlchohol;
  self.alchoholStepper.value = item.itemAlchoholValue;
  self.body.text = item.itemBody;
  self.bodyStepper.value = item.itemBodyValue;
  self.flavorIntensity.text = item.itemFlavorIntensity;
  self.flavorIntensityStepper.value = item.itemFlavorIntensityValue;
  self.flavorsTextView.text = item.itemFlavors;
  self.balanceTextField.text = item.itemBalance;
  self.mousse.text = item.itemMousse;
  self.mousseStepper.value = item.itemMousseValue;
  self.finish.text = item.itemFinish;
  self.finishStepper.value = item.itemFinishValue;
  self.qualityLabel.text = item.itemQuality;
  self.qualitySlider.value = item.itemQualityValue;
  self.readinessTextField.text = item.itemReadiness;
  self.winemakerTextField.text = item.itemWinemaker;
  self.vintageTextField.text = item.itemVintage;
  self.appellationTextField.text = item.itemAppellation;
  self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
  
  /*
   self.nameTextView.text = item.itemName;
   self.vintageTextField.text = item.vintage;
   self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
   */
  
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
  item.itemNotes = self.notesTextView.text;
  item.itemClarity = self.clarityLabel.text;
  item.itemClarityValue = self.claritySlider.value;
  item.itemColor = self.colorLabel.text;
  item.itemColorValue = self.colorSlider.value;
  item.itemColorIntensity = self.colorIntensity.text;
  item.itemColorIntensityValue = self.colorIntensityStepper.value;
  item.itemColorShade = self.colorShadeLabel.text;
  item.itemColorShadeValue = self.colorShadeSlider.value;
  item.itemPetillance = self.petillance.text;
  item.itemPetillanceValue = self.petillanceStepper.value;
  item.itemViscosity = self.viscosity.text;
  item.itemViscosityValue = self.viscosityStepper.value;
  item.itemSediment = self.sedimentLabel.text;
  item.itemSedimentValue = self.sedimentSlider.value;
  item.itemCondition = self.conditionLabel.text;
  item.itemConditionSliderValue = self.conditionSlider.value;
  item.itemAromaIntensity = self.aromaIntensity.text;
  item.itemAromaIntensityValue = self.aromaIntensityStepper.value;
  item.itemAromas = self.aromasTextView.text;
  item.itemDevelopment = self.development.text;
  item.itemDevelopmentValue = self.developmentStepper.value;
  item.itemSweetness = self.sweetness.text;
  item.itemSweetnessValue = self.sweetnessStepper.value;
  item.itemAcidity = self.acidity.text;
  item.itemAcidityValue = self.acidityStepper.value;
  item.itemTannin = self.tannin.text;
  item.itemTanninValue = self.tanninStepper.value;
  item.itemAlchohol = self.alchohol.text;
  item.itemAlchoholValue = self.alchoholStepper.value;
  item.itemBody = self.body.text;
  item.itemBodyValue = self.bodyStepper.value;
  item.itemFlavorIntensity = self.flavorIntensity.text;
  item.itemFlavorIntensityValue = self.flavorIntensityStepper.value;
  item.itemFlavors = self.flavorsTextView.text;
  item.itemBalance = self.balanceTextField.text;
  item.itemMousse = self.mousse.text;
  item.itemMousseValue = self.mousseStepper.value;
  item.itemFinish = self.finish.text;
  item.itemFinishValue = self.finishStepper.value;
  item.itemQuality = self.qualityLabel.text;
  item.itemQualityValue = self.qualitySlider.value;
  item.itemReadiness = self.readinessTextField.text;
  item.itemWinemaker = self.winemakerTextField.text;
  item.itemVintage = self.vintageTextField.text;
  item.itemAppellation = self.appellationTextField.text;
  /*
  item.itemName = self.nameTextView.text;
  item.vintage = self.vintageTextField.text;
  */
  int newValue = [self.priceTextField.text intValue];
  
  if (newValue != item.valueInDollars) {
    item.valueInDollars = newValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:newValue forKey:NextItemValuePrefsKey];
  }
}

@end

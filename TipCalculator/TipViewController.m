//
//  ViewController.m
//  TipCalculator
//
//  Created by Mohit Sachan on 4/11/15.
//  Copyright (c) 2015 Mohit Sachan. All rights reserved.
//

#import "TipViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KeyConstants.h"

@interface TipViewController ()
@property(weak, nonatomic) IBOutlet UITextField *billTextField;
@property(weak, nonatomic) IBOutlet UITextField *tipAmountLabel;
@property(weak, nonatomic) IBOutlet UITextField *totalAmountLabel;
@property(weak, nonatomic) IBOutlet UISegmentedControl *tipSelectionControl;
@property(weak, nonatomic) IBOutlet UITextField *tipIconLabel;
@property(weak, nonatomic) NSString *currencySign;
@property(assign, nonatomic) NSInteger defaultValue;
@property(strong, nonatomic, readonly) NSUserDefaults* nsUserDefaults;

- (IBAction)onTap:(id)sender;

@end

@implementation TipViewController

@synthesize nsUserDefaults = _nsUserDefaults;

-(NSUserDefaults*) nsUserDefaults
{
    if (!_nsUserDefaults) {
        _nsUserDefaults = NSUserDefaults.standardUserDefaults;
    }
    return _nsUserDefaults;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.navigationController.title = @"Tip Calculator";
  self.currencySign = @"$";
  [self.billTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-1.jpg"]];

  [self.tipSelectionControl addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventValueChanged];

    
    UILabel *plusLabel = [[UILabel alloc] init];
    plusLabel.text = @"+";
    [plusLabel sizeToFit];

    UILabel *percentLabel = [[UILabel alloc] init];
    percentLabel.text = @"%";
    [percentLabel sizeToFit];

    self.tipIconLabel.leftView = plusLabel;
    self.tipIconLabel.leftViewMode = UITextFieldViewModeAlways;

    self.tipIconLabel.rightView = percentLabel;
    self.tipIconLabel.rightViewMode = UITextFieldViewModeAlways;

    
    // if time since last bill amount was enter is less than 10 minutes, update the old values
//    if([[self.nsUserDefaults objectForKey:timeStamp] timeIntervalSinceNow] < 1*60)
    NSDate* lastDate = [self.nsUserDefaults valueForKey:timeStamp];
    if([[NSDate date] timeIntervalSinceDate:lastDate] <1*60)
    {
        self.billTextField.text = [self.nsUserDefaults objectForKey:billAmountValue];
        [self updateValuesWithTipPercent];
    }
    else
    {
        self.billTextField.text = @"";
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  [self updateSelectionValues];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
          [self.billTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString* currentDefault = [self stripTheSign:@"%" AndConvert:[self.tipSelectionControl titleForSegmentAtIndex:self.tipSelectionControl.selectedSegmentIndex]];
    
    [self.nsUserDefaults setObject:currentDefault forKey:defaultTipAmount];

    NSString* first = [self stripTheSign:@"%" AndConvert:[self.tipSelectionControl titleForSegmentAtIndex:0]];
    NSString* second = [self stripTheSign:@"%" AndConvert:[self.tipSelectionControl titleForSegmentAtIndex:1]];

    NSString* third = [self stripTheSign:@"%" AndConvert:[self.tipSelectionControl titleForSegmentAtIndex:2]];

    
    switch (self.tipSelectionControl.selectedSegmentIndex) {
        case 0:
            [self.nsUserDefaults setObject:second forKey:OtherTipAmount_1];
            
            [self.nsUserDefaults setObject:third forKey:OtherTipAmount_2];
            
            break;
        case 1:
            [self.nsUserDefaults setObject:first forKey:OtherTipAmount_1];
            
            [self.nsUserDefaults setObject:third forKey:OtherTipAmount_2];
            break;
            
        case 2:
            [self.nsUserDefaults setObject:first forKey:OtherTipAmount_1];
            
            [self.nsUserDefaults setObject:second forKey:OtherTipAmount_2];
            break;
            }
    
    [self.nsUserDefaults synchronize];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)textFieldDidChange:(id)sender {
  if ([sender isKindOfClass:[UITextField class]]) {
    UITextField *billTextField = (UITextField *)sender;
    if (![billTextField.text hasPrefix:self.currencySign]) {
      billTextField.text = [NSString stringWithFormat:@"%@%@", self.currencySign, billTextField.text];
    } else if ([billTextField.text isEqualToString:self.currencySign]) {
      billTextField.text = @"";
    }
  }
    else if([sender isKindOfClass:[UISegmentedControl class]])
    {
        self.tipIconLabel.text = [self stripTheSign:@"%" AndConvert:[ self.tipSelectionControl titleForSegmentAtIndex:self.tipSelectionControl.selectedSegmentIndex]];
    }
  [self updateValuesWithTipPercent];
}


- (IBAction)onTap:(id)sender {
  [self.view endEditing:YES];
}


-(NSArray*) getArrayOfValues
{
    NSString* defaultValue =  [self.nsUserDefaults objectForKey:defaultTipAmount] == nil? @"10":[self.nsUserDefaults objectForKey:defaultTipAmount];
    NSString* option1 = [self.nsUserDefaults objectForKey:OtherTipAmount_1] == nil? @"15":[self.nsUserDefaults objectForKey:OtherTipAmount_1];
    NSString* option2 = [self.nsUserDefaults objectForKey:OtherTipAmount_2] == nil? @"20":[self.nsUserDefaults objectForKey:OtherTipAmount_2];
    NSArray* array = @[defaultValue, option1, option2];
    
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        float first = [a floatValue];
        float second = [b floatValue];
        return first >second;
    }];
    
    return sortedArray;
}
- (void)updateSelectionValues {
    
    NSArray *sortedArray = [self getArrayOfValues];
    float defaultValue = [[[NSUserDefaults standardUserDefaults] objectForKey:defaultTipAmount] floatValue];
    
    if (sortedArray) {
        for (int i = 0; i < 3; i++) {
            
            if ([sortedArray[i] floatValue] != 0) {
                if ([sortedArray[i] floatValue] == defaultValue) {
                    self.tipSelectionControl.selectedSegmentIndex = i;
                }
                [self.tipSelectionControl setTitle:[NSString stringWithFormat:@"%@%@",sortedArray[i], @"%"] forSegmentAtIndex:i];
            }
        }
    }
    self.tipIconLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:defaultTipAmount];
    [self updateValuesWithTipPercent];
}

- (void)updateValuesWithTipPercent {
    
    NSArray *tipValues = @[
                           @([[self.tipSelectionControl titleForSegmentAtIndex:0] floatValue] / 100),
                           @([[self.tipSelectionControl titleForSegmentAtIndex:1] floatValue] / 100),
                           @([[self.tipSelectionControl titleForSegmentAtIndex:2] floatValue] / 100)
                           ];
    float billAmount = [[self stripTheSign:@"$" AndConvert:self.billTextField.text] floatValue];
    float tipAmount = billAmount * [tipValues[self.tipSelectionControl.selectedSegmentIndex] floatValue];
    if (!tipAmount == 0) {
        
        self.tipAmountLabel.text = [NSString stringWithFormat:@"%@%.2f", self.currencySign, tipAmount];
        self.totalAmountLabel.text = [NSString stringWithFormat:@"%@%.2f", self.currencySign, tipAmount + billAmount];
    } else {
        self.tipAmountLabel.text = @"";
        self.totalAmountLabel.text = @"";
    }
    if (![self.billTextField.text  isEqualToString: @""] || self.billTextField.text != nil) {
        [self.nsUserDefaults setObject:self.billTextField.text forKey:billAmountValue];
        [self.nsUserDefaults setObject:[NSDate date] forKey:timeStamp];
        [self.nsUserDefaults synchronize];
    }

}

- (NSString*)stripTheSign:(NSString*)sign AndConvert:(NSString *)valueString {
  if ([valueString containsString:sign]) {
    valueString = [valueString stringByReplacingOccurrencesOfString:sign withString:@""];
  }
    return valueString;
}
@end

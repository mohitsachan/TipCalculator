//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Mohit Sachan on 4/13/15.
//  Copyright (c) 2015 Mohit Sachan. All rights reserved.
//

#import "SettingsViewController.h"
#import "KeyConstants.h"

@interface SettingsViewController ()
@property(weak, nonatomic) IBOutlet UITextField *defaultTextField;
@property(weak, nonatomic) IBOutlet UITextField *minimumTextField;
@property(weak, nonatomic) IBOutlet UITextField *maximumTextField;
//@property(strong, nonatomic) NSMutableArray* tipSelectionArray;
@property(strong, nonatomic, readonly) NSUserDefaults *nsUserDefaults;
- (IBAction)onTap:(id)sender;

@end


@implementation SettingsViewController

@synthesize nsUserDefaults = _nsUserDefaults;
//@synthesize tipSelectionArray = _tipSelectionArray;


//-(NSMutableArray*)tipSelectionArray
//{
//    if(!_tipSelectionArray)
//    {
//        _tipSelectionArray = [self.nsUserDefaults objectForKey:tipSelectionArray];
//    }
//    return _tipSelectionArray;
//}
- (NSUserDefaults *)nsUserDefaults {
  if (!_nsUserDefaults) {
    _nsUserDefaults = NSUserDefaults.standardUserDefaults;
  }
  return _nsUserDefaults;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  UILabel *percentLabel = [[UILabel alloc] init];
  percentLabel.text = @"%";
  [percentLabel sizeToFit];
    
  self.defaultTextField.rightView = percentLabel;
  self.defaultTextField.rightViewMode = UITextFieldViewModeAlways;

    UILabel *percentLabel1 = [[UILabel alloc] init];
    percentLabel1.text = @"%";
    [percentLabel1 sizeToFit];

    self.minimumTextField.rightView = percentLabel1;
    self.minimumTextField.rightViewMode = UITextFieldViewModeAlways;

    UILabel *percentLabel2 = [[UILabel alloc] init];
    percentLabel2.text = @"%";
    [percentLabel2 sizeToFit];

    self.maximumTextField.rightView = percentLabel2;
    self.maximumTextField.rightViewMode = UITextFieldViewModeAlways;

  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-1.jpg"]];

    [self.defaultTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.minimumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.maximumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateValues];
}

- (void)updateValues {
  self.defaultTextField.text = [self.nsUserDefaults objectForKey:defaultTipAmount];
    
    self.minimumTextField.text = [self.nsUserDefaults objectForKey:OtherTipAmount_1];
    
    self.maximumTextField.text = [self.nsUserDefaults objectForKey:OtherTipAmount_2];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    [self onBackButtonPressed:nil];
  }
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (void)textFieldDidChange:(id)sender {
    if ([sender isKindOfClass:[UITextField class]]) {
        UITextField* textField = (UITextField*)sender;
        switch (textField.tag) {
            case 1001:
//                self.tipSelectionArray[1] = textField.text;
                [self.nsUserDefaults setObject:textField.text forKey:defaultTipAmount];
                break;
            case 1002:
                //self.tipSelectionArray[0] = textField.text;
                [self.nsUserDefaults setObject:textField.text forKey:OtherTipAmount_1];
                break;
            case 1003:
                //self.tipSelectionArray[2] = textField.text;
                [self.nsUserDefaults setObject:textField.text forKey:OtherTipAmount_2];
                break;
        }
    }
    
}

- (void)onBackButtonPressed:(id)sender {
  [self.nsUserDefaults synchronize];
}

- (IBAction)onTap:(id)sender {
  [self.view endEditing:YES];
}
@end

//
//  PhoneVerificationViewController.m
//  AppsMobileCompany
//
//  Created by Bonnie Jaiswal on 11/20/19.
//

#import "PhoneVerificationViewController.h"

@interface PhoneVerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblLoginMessage;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (nonatomic) NSString *verificationID;
@property (nonatomic) BOOL isPhoneNumberMode;
@property (nonatomic) FIRUser *loggedInUser;
@end

@implementation PhoneVerificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
   // _phoneNumberTextField.setFlag(for: .KE)
  //  _phoneNumberTextField.set(phoneNumber: "724 087525")
  //  [self.delegate _phoneNumberTextField:self];
  self.isPhoneNumberMode = true;
  [self configureUI];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startPhoneAuth];
    });

}

-(void)startPhoneAuth {

    [FUIAuth defaultAuthUI].delegate = self; // delegate should be retained by you!
    FUIPhoneAuth *phoneProvider = [[FUIPhoneAuth alloc] initWithAuthUI:[FUIAuth defaultAuthUI]];
    [FUIAuth defaultAuthUI].providers = @[phoneProvider];
//    FUIPhoneAuth *phoneProvider = [FUIAuth defaultAuthUI].providers.firstObject;
    [phoneProvider signInWithPresentingViewController:self phoneNumber:nil];

}

- (IBAction)sendCodeButtonPressed:(id)sender {

  if (self.isPhoneNumberMode) {
    [self sendPhoneNumber];
  } else {
    [self checkVerificationCode];
  }
}

- (IBAction)resetButtonPressed:(id)sender {
  self.isPhoneNumberMode = true;
  [self configureUI];
}

-(void)sendPhoneNumber {

  NSString *phNUmber = self.phoneNumberTextField.text;
  if (phNUmber.length > 0) {
    [FIRPhoneAuthProvider.provider
     verifyPhoneNumber:phNUmber
     UIDelegate:nil
     completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
       if (error == nil) {
         [self showAlertWithText:(@"Phone Number verification Code Sent")];
         self.verificationID = verificationID;
         self.isPhoneNumberMode = false;
         [self configureUI];
       } else {
         [self showAlertWithText:@"There was an error sending code, Please check the phone number.\n Please Include Country code."];
         self.isPhoneNumberMode = true;
         [self configureUI];
         NSLog(@"%@", error.localizedDescription);
       }
     }];
  }
}

-(void)checkVerificationCode {

  NSString *code = self.phoneNumberTextField.text;
  if (code.length > 0) {

    FIRAuthCredential *credential =
    [[FIRPhoneAuthProvider provider] credentialWithVerificationID:self.verificationID
                                                 verificationCode:code];

    [[FIRAuth auth]
     signInWithCredential:credential
     completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {

       if (error) {
         // Handles error
         [self showAlertWithText:@"There was an error verifying the code"];
         self.isPhoneNumberMode = true;
         [self configureUI];
         NSLog(@"%@", error.localizedDescription);
       }
       else {
         self.loggedInUser = user;
         [self showAlertWithText:@"Verification Successfull"];
         NSLog(@"Used ID = %@", self.loggedInUser.uid);
         self.isPhoneNumberMode = YES;
         [self configureUI];
       }
     }];
  }
}

-(void)configureUI {

  if (self.isPhoneNumberMode) {
    _phoneNumberTextField.text = nil;
    _phoneNumberTextField.textContentType = UITextContentTypeTelephoneNumber;
    self.lblLoginMessage.text = @"Login\nEnter Phone Number and press Send Code";
    [self.btnSend setTitle:@"Send Code" forState:UIControlStateNormal];
    [_phoneNumberTextField resignFirstResponder];
  } else {
    _phoneNumberTextField.text = nil;
    _phoneNumberTextField.textContentType = UITextContentTypeOneTimeCode;
    self.lblLoginMessage.text = @"Verify\nEnter 6 digit code recieved";
    [self.btnSend setTitle:@"Verify Code" forState:UIControlStateNormal];
    [_phoneNumberTextField resignFirstResponder];
  }
}

-(void)showAlertWithText:(NSString *)text {

  UIAlertController * alert = [UIAlertController
                               alertControllerWithTitle:@"Pickups"
                               message:text
                               preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
  [alert addAction:okAction];
  [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch * touch = [touches anyObject];
  if(touch.phase == UITouchPhaseBegan) {
    [_phoneNumberTextField resignFirstResponder];
  }
}

//- (void)fpnDidSelectCountryWithName:(NSString * _Nonnull)name dialCode:(NSString * _Nonnull)dialCode code:(NSString * _Nonnull)code {
//    NSLog(@"%@ %@ %@", name, dialCode, code);
//}

//-(void)fpnDidValidatePhoneNumberWithTextField:(FPNTextField * _Nonnull)textField isValid:(BOOL)isValid {
//    UIImage *img = isValid ? [UIImage imageNamed: @"success"] : [UIImage imageNamed: @"error"];
//
//    _phoneNumberTextField.rightViewMode = UITextFieldViewModeAlways;
//    _phoneNumberTextField.rightView = [[UIImageView alloc] initWithImage: img];
//
//    NSLog(@"is valid: %@", isValid ? @"Yes" : @"No");
////    NSLog(@"E164 Format: %@", [_phoneNumberTextField getFormattedPhoneNumberWithFormat: FPNFormatE164]);
////    NSLog(@"International Format: %@", [_phoneNumberTextField getFormattedPhoneNumberWithFormat: FPNFormatInternational]);
////    NSLog(@"National Format: %@", [_phoneNumberTextField getFormattedPhoneNumberWithFormat: FPNFormatNational]);
////    NSLog(@"RFC3966 Format: %@", [_phoneNumberTextField getFormattedPhoneNumberWithFormat: FPNFormatRFC3966]);
////    NSLog(@"Raw: %@", [_phoneNumberTextField getRawPhoneNumber]);
//}


/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end

//
//  PhoneVerificationViewController.m
//  AppsMobileCompany
//
//  Created by Bonnie Jaiswal on 11/20/19.
//

#import "PhoneVerificationViewController.h"

@interface PhoneVerificationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblLoginMessage;
@property (weak, nonatomic) IBOutlet FPNTextField *txtPhoneNumCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (nonatomic) NSString *verificationID;
@property (nonatomic) BOOL isPhoneNumberMode;
@property (nonatomic) FIRUser *loggedInUser;
@end

@implementation PhoneVerificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    _txtPhoneNumCode.setFlag(for: .KE)
    _txtPhoneNumCode.set(phoneNumber: "724 087525")
    [self.delegate _txtPhoneNumCode:self];
  self.isPhoneNumberMode = true;
  [self configureUI];

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

  NSString *phNUmber = _txtPhoneNumCode.text;
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

  NSString *code = _txtPhoneNumCode.text;
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
    self.txtPhoneNumCode.text = nil;
    self.txtPhoneNumCode.textContentType = UITextContentTypeTelephoneNumber;
    self.lblLoginMessage.text = @"Login\nEnter Phone Number and press Send Code";
    [self.btnSend setTitle:@"Send Code" forState:UIControlStateNormal];
    [self.txtPhoneNumCode resignFirstResponder];
  } else {
    self.txtPhoneNumCode.text = nil;
    self.txtPhoneNumCode.textContentType = UITextContentTypeOneTimeCode;
    self.lblLoginMessage.text = @"Verify\nEnter 6 digit code recieved";
    [self.btnSend setTitle:@"Verify Code" forState:UIControlStateNormal];
    [self.txtPhoneNumCode resignFirstResponder];
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
    [self.txtPhoneNumCode resignFirstResponder];
  }
}

-(void)fpnDidSelectCountry: (NSString *)name: (NSString *)dialCode: (NSString *)code {
   print(name, dialCode, code) // Output "France", "+33", "FR"
}

-(void)fpnDidValidatePhoneNumber: (FPNTextField *)textField: (BOOL *) isValid {
   if isValid {
      // Do something...
      textField.getFormattedPhoneNumber(format: .International),  // Output "+33 6 00 00 00 01"
      textField.getFormattedPhoneNumber(format: .National),       // Output "06 00 00 00 01"
      textField.getFormattedPhoneNumber(format: .RFC3966),        // Output "tel:+33-6-00-00-00-01"
      textField.getRawPhoneNumber()                               // Output "600000001"
   } else {
      // Do something...
   }
}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end

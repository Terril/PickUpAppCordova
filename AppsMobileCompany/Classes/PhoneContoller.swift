//
//  PhoneVerificationContoller.swift
//  AppsMobileCompany
//
//  Created by Terril Thomas on 19/11/19.
//

import Foundation
import UIKit
import FirebaseAuth
import PhoneVerificationController

@objc(PhoneContoller)
class PhoneContoller : UIViewController {
 
    
    override func viewDidLoad() {
    
     let configuration = Configuration(requestCode: { phone, completion in
             PhoneAuthProvider.provider().verifyPhoneNumber(phone, completion: completion)
         }, signIn: { verificationID, verificationCode, completion in
             let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
             Auth.auth().signIn(with: credential) { _, error in completion(error) }
         })
         let vc = PhoneVerificationController(configuration: configuration)
        vc.delegate = self
         present(vc, animated: true)
    }
}

extension PhoneContoller: PhoneVerificationDelegate {
    func cancelled(controller: PhoneVerificationController) {
        print("Cancelled verification")
        controller.dismiss(animated: true)
    }

    func verified(phoneNumber: String, controller: PhoneVerificationController) {
        print("Verified phone \(phoneNumber)")
        controller.dismiss(animated: true)
    }
}

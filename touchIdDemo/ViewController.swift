//
//  ViewController.swift
//  touchIdDemo
//
//  Created by Zsombor on 2019. 04. 13..
//  Copyright © 2019. Zsombor. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var StatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.authenticateUsingTouchID()
    }

    private func authenticateUsingTouchID(){
        let context = LAContext()
        var errorPointer: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorPointer){
            NSLog("OK")
            requestTouchIdValidation(usingContext: context)
        } else {
            DispatchQueue.main.async {
                self.StatusLabel.text = "No TouchID available."
            }
        }
    }
    
    private func requestTouchIdValidation(usingContext context: LAContext) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login Using Your Magic Touch") { (success, error) in
            
            if success {
                DispatchQueue.main.async {
                    // CONGRATULATIONS: handle success authentication =)
                    self.StatusLabel.text = "Successfully logged in :)"
                }
            }
            else {
                let error = error as! LAError
                
                switch error.code {
                case LAError.authenticationFailed:
                    break
                case LAError.userCancel:
                    DispatchQueue.main.async {
                        self.StatusLabel.text = "Canceled."
                    }
                    break
                case LAError.userFallback:
                    DispatchQueue.main.async {
                        self.StatusLabel.text = "Fallback."
                    }
                    break
                case LAError.biometryNotEnrolled:
                    DispatchQueue.main.async {
                        self.StatusLabel.text = "Not enrolled."
                    }
                    break
                case LAError.passcodeNotSet:
                    DispatchQueue.main.async {
                        self.StatusLabel.text = "Passcode not set."
                    }
                    break
                case LAError.systemCancel:
                    // canceled by the system
                    break
                default:
                    // other
                    break
                }
            }
        }
    }
}


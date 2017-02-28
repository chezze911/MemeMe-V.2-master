//
//  MemeTextFieldDelegate.swift
//  MemeMe V.2
//
//  Created by Chi Nguyen on 1/22/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        func textFieldDidBeginEditing(textField: UITextField) {
            textField.text = ""
        }
        
        var newText: NSString = textField.text! as NSString
  
        newText = newText.replacingCharacters(in: range, with: string) as NSString

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

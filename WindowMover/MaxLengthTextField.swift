//
//  MaxLengthTextField.swift
//  WindowMover
//
//  Created by Quentin Wendegass on 24.01.18.
//  Copyright © 2018 Quentin Wendegass. All rights reserved.
//

import AppKit

class MaxLengthTextField: NSTextField, NSTextFieldDelegate {
    
    private var characterLimit: Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    
    // 1
    func textField(_ textField: NSTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 2
        guard string.count > 0 else {
            return true
        }
        
        // 3
        let currentText = textField.stringValue
        // 4
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        // 5
        return prospectiveText.count <= maxLength
    }
}

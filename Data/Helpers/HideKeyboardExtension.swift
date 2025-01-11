//
//  HideKeyboardExtension.swift
//  Tracker
//
//  Created by Кирилл Дробин on 24.12.2024.
//

import UIKit

extension UIViewController: @retroactive UITextFieldDelegate, @retroactive UISearchTextFieldDelegate {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldShouldClear(_ textField: UISearchTextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

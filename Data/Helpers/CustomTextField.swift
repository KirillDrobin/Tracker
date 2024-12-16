//
//  CustomTextField.swift
//  Tracker
//
//  Created by Кирилл Дробин on 14.12.2024.
//

import UIKit

class CustomTextField: UITextField {

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: 16, y: 0, width: bounds.width, height: bounds.height)
    }
}

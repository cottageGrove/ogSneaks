//
//  SneakerEntryView.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-20.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit

protocol SneakerEntryDelegate {
    func onSneakerUpload(sneaker: Sneaker)
    func onSelectImageScreen()
    func onSneakerNameBeginEditing(sneakerName: String)
}

class SneakerEntryView: UIView, UITextFieldDelegate {
    
//    var sneaker = Sneaker()
    
    var sneaker : Sneaker! {
        didSet {

            guard let name = sneaker.name else {return}
            guard let size = sneaker.size else {return}
            guard let price = sneaker.price else {return}
            guard let year = sneaker.year else {return}

            
            sneakerModelTextField?.text = String(name)
            sizeTextField?.text = String(size)
            priceTextField?.text = String(price)
            yearTextField?.text = String(year)
            
            print("size \(size)")
            print("price \(price)")
            print("year \(year)")
        }

    }
    
    
    
    @IBOutlet weak var sneakerModelTextField : UITextField?
    @IBOutlet weak var sizeTextField: UITextField?
    @IBOutlet weak var priceTextField: UITextField?
    @IBOutlet weak var yearTextField: UITextField?
    var delegate: SneakerEntryDelegate?
    

    
//    init() {
//        super.init()
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        sizeTextField?.delegate = self
//        priceTextField?.delegate = self
//        yearTextField?.delegate = self
//
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sneakerModelTextField?.delegate = self
        sizeTextField?.delegate = self
        priceTextField?.delegate = self
        yearTextField?.delegate = self
        
//        self.setupKeyboard()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y == 0 {
                self.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.frame.origin.y != 0 {
            self.frame.origin.y = 0
        }
    }
    
    
    

    
    
    @IBAction func onSneakerConditionTap(_ sender : Any) {
        
        let button = sender as! UIButton
        
        guard let condition = button.titleLabel?.text else {return}
        sneaker.condition = condition
        
        print("The condition of the item is \(sneaker.condition)")
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        

        var value : Bool!

        if textField == sneakerModelTextField {

            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            print("before sneaker name: \(updatedText)")
            delegate?.onSneakerNameBeginEditing(sneakerName: updatedText!)
            
            value = true
        }

        if textField == sizeTextField {
            value = checkInput(charactersInString: string)
        }

        if textField == yearTextField {
            value = checkInput(charactersInString: string)
        }

        if textField == priceTextField {
            value = checkInput(charactersInString: string)
        }

        return value
    }
    
    
    func checkInput(charactersInString : String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: charactersInString)
        let intValue = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
        return intValue
    }
    
    @IBAction func goToImageSelection() {
        
        self.delegate?.onSelectImageScreen()
    }
    
    @IBAction func uploadSneaker(_sender : Any) {
        
//        sizeTextField?.contains
        
        var updatedSneaker = Sneaker()
        
        updatedSneaker.name = sneakerModelTextField?.text
        
        guard let size = sizeTextField?.text else {return}
        guard let price = priceTextField?.text else {return}
        guard let year = yearTextField?.text else {return}
        
        updatedSneaker.size = Int(size)
        updatedSneaker.price = Int(price)
        updatedSneaker.year = Int(year)
        updatedSneaker.condition = sneaker.condition
        
//        sneakerModelTextField?.text
        
        print("Sneaker name is \(updatedSneaker.name)")
        print("Sneaker size is \(updatedSneaker.size)")
        print("Sneaker made in \(updatedSneaker.year)")
        print("Sneaker price is \(updatedSneaker.price)")
        print("Sneaker condition is \(updatedSneaker.condition)")
        
        self.delegate?.onSneakerUpload(sneaker: updatedSneaker)

        
    }
    
    
    
}

//
//  oneTimeRecoveryCodeView.swift
//  GoBasket
//
//  Created by Borys on 28.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

class oneTimeRecoveryCodeView: UIViewController, DigitInputViewDelegate {

    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var resumeBtn: UIButton!
    
    var phoneNumber: String!
    var digitInput = DigitInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.standardAppearance.setBackIndicatorImage(UIImage(named: "arrowRight"), transitionMaskImage: UIImage(named: "arrowRight"))
        self.navigationController?.navigationBar.tintColor = .none
        self.navigationController?.navigationBar.tintColor = UIColor(named: "#black&white")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        lblPhoneNumber.text?.append(phoneNumber)
 
        digitInput = DigitInputView()
            
        digitInput.numberOfDigits = 4
        digitInput.bottomBorderColor = UIColor(named: "#lightGreyBlue")!
        digitInput.nextDigitBottomBorderColor = UIColor(named: "#black&white")!
        digitInput.textColor = UIColor(named: "#black&white")!
        digitInput.acceptableCharacters = "0123456789"
        digitInput.keyboardType = .numberPad
        digitInput.font = UIFont.systemFont(ofSize: 40)
        digitInput.animationType = .dissolve
        digitInput.keyboardAppearance = .default
        
        digitInput.delegate = self
        
        digitInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(digitInput)
        
        digitInput.topAnchor.constraint(equalTo: lblPhoneNumber.bottomAnchor, constant: 30).isActive = true
        digitInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        digitInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        digitInput.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        resumeBtn.isEnabled = false
        resumeBtn.backgroundColor = UIColor.init(named: "#buttonDisable")
        resumeBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
            
        _ = digitInput.becomeFirstResponder()
    }
        
    @objc func digitsDidChange(digitInputView: DigitInputView) {
        if digitInput.text.count == 4 {
            resumeBtn.isEnabled = true
            resumeBtn.backgroundColor = UIColor.init(named: "#buttonEnable")
            resumeBtn.setTitleColor(UIColor.init(named: "#buttonEnableText"), for: .normal)
        } else {
            resumeBtn.isEnabled = false
            resumeBtn.backgroundColor = UIColor.init(named: "#buttonDisable")
            resumeBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        }
    }
        
    @objc func digitsDidFinish(digitInputView: DigitInputView) {
        _ = digitInput.resignFirstResponder()
        if digitInput.text.count == 4 {
            resumeBtn.isEnabled = true
            resumeBtn.backgroundColor = UIColor.init(named: "#buttonEnable")
            resumeBtn.setTitleColor(UIColor.init(named: "#buttonEnableText"), for: .normal)
        } else {
            resumeBtn.isEnabled = false
            resumeBtn.backgroundColor = UIColor.init(named: "#buttonDisable")
            resumeBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        }
    }
    
    @IBAction func pressResumeBtn(_ sender: UIButton) {

    }

}

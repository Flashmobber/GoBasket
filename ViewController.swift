//
//  ViewController.swift
//  GoBasket
//
//  Created by Borys on 14.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showPswdBtn: UIButton!
    @IBOutlet weak var lblUsersAgreement: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    var isClearButtonPressed: Bool = false
    var pixelWidthLogin: CGFloat = 0.0
    var pixelWidthPassword: CGFloat = 0.0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        login.delegate = self // переопределяю обработчик нажатия Clear Button в login.UITextField
        lblLogin.frame.origin.x = login.frame.origin.x
        lblLogin.frame.origin.y = login.frame.origin.y+8
        lblPassword.frame.origin.x = password.frame.origin.x
        lblPassword.frame.origin.y = password.frame.origin.y+8
        password.rightView = showPswdBtn
        password.rightViewMode = .always
        let agreemet = NSMutableAttributedString(string: "Продолжая, вы принимаете условия ")
        agreemet.append(NSAttributedString(string: "пользовательского соглашения", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]))
        lblUsersAgreement.attributedText = agreemet
        self.setupLabelTap()  // подключаем обработчик события нажатия на lblUserAgreemet
        loginBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        // расстояние в пикселях для смещения в лево lblLogin и lblPassword
        pixelWidthLogin = (lblLogin.intrinsicContentSize.width - (lblLogin.intrinsicContentSize.width*0.85))/2
        pixelWidthPassword = (lblPassword.intrinsicContentSize.width - (lblPassword.intrinsicContentSize.width*0.85))/2
        self.hideKeyboardWhenTappedAround() // обработчик нажатия UIView для скрытия клавиатуры
    }
    
    //+++++ обработчик события нажатия на lblUserAgreemet +++++
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "userAgreementSegue", sender: nil)
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.lblUsersAgreement.isUserInteractionEnabled = true
        self.lblUsersAgreement.addGestureRecognizer(labelTap)
    }
    //=========
    
    @IBAction func unwindToLoginScr(_ segue: UIStoryboardSegue) {
        // возврат с окна пользовательского соглашения
    }
    
    @IBAction func unwindToLoginFromPswdRecovery(_ segue: UIStoryboardSegue) {
        // возврат с окна восстановления пароля
    }
    
    @IBAction func unwindToLoginFromORC(_ segue: UIStoryboardSegue) {
        // возврат с окна восстановления пароля
    }


    @objc func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // обработчик нажатия Clear Button в login.UITextField
        textField.text = ""
        textField.resignFirstResponder()
        if !isClearButtonPressed {
           editingEnd(textField)
           editingChanged(textField)
        }
        isClearButtonPressed = true
        return false
    }
    
    //+++++ изменяем цвет текста и доступность кнопки "Войти" +++++
    
    @IBAction func editingChanged(_ sender: UITextField) {
        print("Changed Start")
        if login.text!.count >= 17 && !password.text!.isEmpty {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = UIColor.init(named: "#buttonEnable")
            loginBtn.setTitleColor(UIColor.init(named: "#buttonEnableText"), for: .normal)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor.init(named: "#buttonDisable")
            loginBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        }
        if (sender.tag == 0) && (sender.text!.count < 5) {
            sender.text = isClearButtonPressed ? "" : "+38(0"
            isClearButtonPressed = false
        }
            
        if sender.tag == 0 {
            sender.text = formattedNumber(number: sender.text!)
        }
    }
    //=========
        
    @IBAction func editingBegin(_ sender: UITextField) {
        isClearButtonPressed = false
        print("Editing Begin Start")
        if sender.text!.isEmpty {
            switch sender.tag {
             case 0: do {
                UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                self.lblLogin.frame.origin.y -= 19
                self.lblLogin.frame.origin.x -= self.pixelWidthLogin
                self.lblLogin.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
             }, completion: nil)
                UIView.transition(with: self.lblLogin, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.lblLogin.textColor = UIColor(named: "#black&white")
                 }, completion: nil)
                UIView.transition(with: self.login! , duration: 0.35, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.login.text = "+38(0"
                     self.login.background = UIImage(named: "textFieldLineBold")
                 }, completion: nil)
                print("Login Begin Animate")
                }
             case 1: do {
                UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                     self.lblPassword.frame.origin.y -= 19
                    self.lblPassword.frame.origin.x -= self.pixelWidthPassword
                     self.lblPassword.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                 }, completion: nil)
                UIView.transition(with: self.lblPassword, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                         self.lblPassword.textColor = UIColor(named: "#black&white")
                     }, completion: nil)
                UIView.transition(with: self.password! , duration: 0.35, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.password.background = UIImage(named: "textFieldLineBold")
                 }, completion: nil)
                 }
            default: do { return }
             }
        }
    }
    
    @IBAction func editingEnd(_ sender: UITextField) {
        isClearButtonPressed = false
        if (sender.text!.isEmpty) || (login.text == "+38(0") || isClearButtonPressed {
            switch sender.tag {
            case 0: do {
                UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                self.lblLogin.frame.origin.y += 19
                self.lblLogin.frame.origin.x += self.pixelWidthLogin
                self.lblLogin.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
                UIView.transition(with: self.lblLogin, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                    self.lblLogin.textColor = UIColor(named: "#lightGreyBlue")
                }, completion: nil)
                UIView.transition(with: self.login! , duration: 0.3, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.login.text = ""
                     self.login.background = UIImage(named: "textFieldLineSlim")
                 }, completion: nil)
                isClearButtonPressed = true
            }
            case 1: do {
                    UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                    self.lblPassword.frame.origin.y += 19
                    self.lblPassword.frame.origin.x += self.pixelWidthPassword
                    self.lblPassword.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
                    UIView.transition(with: self.lblPassword, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                        self.lblPassword.textColor = UIColor(named: "#lightGreyBlue")
                    }, completion: nil)
                    UIView.transition(with: self.password! , duration: 0.35, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                        self.password.background = UIImage(named: "textFieldLineSlim")
                 }, completion: nil)
                }
            default: do { return }
            }
        }
    }
    
    @IBAction func editingExit(_ sender: UITextField) {
        lblLogin.frame.origin.x = login.frame.origin.x
        lblLogin.frame.origin.y = login.frame.origin.y+8
    }
    //+++++ отбражаем пароль, изменяем картинку кнопки "глазик" +++++
    
    @IBAction func showPswdBtn(_ sender: UIButton) {
        if password.isSecureTextEntry {
            password.isSecureTextEntry = false
            showPswdBtn.setImage(UIImage(named: "pswdImgShow"), for: .normal)
        } else {
            password.isSecureTextEntry = true
            showPswdBtn.setImage(UIImage(named: "pswdImgHide"), for: .normal)
        }
        
    }
    
    //=========
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+XX(XXX)XXX-XX-XX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
        
    func showMessage (titleStr: String!, messageStr: String!) {
        let alertWindow = UIAlertController(
        title: titleStr,
        message: messageStr,
        preferredStyle: UIAlertController.Style.alert)
        alertWindow.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        alertWindow.view.tintColor = UIColor(named: "#black&white")
        self.present(alertWindow, animated: true, completion: nil)
    }
    @IBAction func loginButton() {
        if login.text != "" {
            showMessage(titleStr: "ALARM!!!", messageStr: "Функція в процессі розробки.")
        } else {
            showMessage(titleStr: "ALARM!!!", messageStr: "Поле Login не заповнено.")
        }
    }
    

}


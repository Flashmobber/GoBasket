//
//  passwordRecoveryView.swift
//  GoBasket
//
//  Created by Borys on 26.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

class passwordRecoveryView: UIViewController, UITextFieldDelegate {
    
    struct jsonData: Decodable {
        let data: Int8?
        let message: String?
        let status: Int8
    }

    @IBOutlet weak var loginRec: UITextField!
    @IBOutlet weak var recoveryBtn: UIButton!
    @IBOutlet weak var lblLoginRec: UILabel!
    
    var jsonStructure: jsonData!
    var pixelWidthLogin: CGFloat = 0.0
    var isOriginSet: Bool = true
    var isClearButtonPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRec.delegate = self // переопределяю обработчик нажатия Clear Button в loginRec.UITextField
        let backBtn = UIBarButtonItem(image: UIImage(named:"arrowRight"), style: .plain, target: self, action: #selector(backTapped))
        backBtn.tintColor = UIColor.init(named: "#black&white")
        self.navigationItem.leftBarButtonItem = backBtn
        recoveryBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        pixelWidthLogin = (lblLoginRec.intrinsicContentSize.width - (lblLoginRec.intrinsicContentSize.width*0.85))/2
        self.hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lblLoginRec.frame.origin.x = isOriginSet ? loginRec.frame.origin.x : lblLoginRec.frame.origin.x
        lblLoginRec.frame.origin.y = isOriginSet ? loginRec.frame.origin.y+8 : lblLoginRec.frame.origin.y
        isOriginSet = false
    }
    
    @objc func backTapped() {
        performSegue(withIdentifier: "unwindToLoginFromPswdRecovery", sender: nil)
    }

    @IBAction func unwindToRecoveryPswdView(segue: UIStoryboardSegue) {
        // возврат с окна ввод кода
    }

    
    @objc func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // обработчик нажатия Clear Button в loginRec.UITextField
        textField.text = ""
        textField.resignFirstResponder()
        if !isClearButtonPressed {
           editingEnd(textField)
           editingChanged(textField)
        }
        isClearButtonPressed = true
        return false
    }

    @IBAction func editingBegin(_ sender: UITextField) {
        isClearButtonPressed = false
        if sender.text! == "" {
                UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                self.lblLoginRec.frame.origin.y -= 19
                self.lblLoginRec.frame.origin.x -= self.pixelWidthLogin
                self.lblLoginRec.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
             }, completion: nil)
                UIView.transition(with: self.lblLoginRec, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.lblLoginRec.textColor = UIColor(named: "#black&white")
                 }, completion: nil)
                UIView.transition(with: self.loginRec! , duration: 0.35, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.loginRec.text = "+38(0"
                     self.loginRec.background = UIImage(named: "textFieldLineBold")
                 }, completion: nil)
                }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        if loginRec.text!.count >= 17 {
            recoveryBtn.isEnabled = true
            recoveryBtn.backgroundColor = UIColor.init(named: "#buttonEnable")
            recoveryBtn.setTitleColor(UIColor.init(named: "#buttonEnableText"), for: .normal)
        } else {
            recoveryBtn.isEnabled = false
            recoveryBtn.backgroundColor = UIColor.init(named: "#buttonDisable")
            recoveryBtn.setTitleColor(UIColor.init(named: "#buttonDisbleText"), for: .disabled)
        }
        if (sender.tag == 0) && (sender.text!.count < 5) {
            sender.text = isClearButtonPressed ? "" : "+38(0"
            isClearButtonPressed = false
        }
        if sender.tag == 0 {
            sender.text = formattedNumber(number: sender.text!)
        }
    }
    
    @IBAction func editingEnd(_ sender: UITextField) {
        isClearButtonPressed = false
        if (sender.text! == "") || (loginRec.text == "+38(0") || isClearButtonPressed {
                UIView.animate(withDuration: 0.4, delay: 0, options: [.preferredFramesPerSecond60, .curveEaseInOut], animations: {
                self.lblLoginRec.frame.origin.y += 19
                self.lblLoginRec.frame.origin.x += self.pixelWidthLogin
                self.lblLoginRec.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
                UIView.transition(with: self.lblLoginRec, duration: 0.2, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                    self.lblLoginRec.textColor = UIColor(named: "#lightGreyBlue")
                }, completion: nil)
                UIView.transition(with: self.loginRec! , duration: 0.3, options: [.preferredFramesPerSecond60, .transitionCrossDissolve], animations: {
                     self.loginRec.text = ""
                     self.loginRec.background = UIImage(named: "textFieldLineSlim")
                 }, completion: nil)
            isClearButtonPressed = true
        }
    }
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? oneTimeRecoveryCodeView else { return }
        dvc.phoneNumber = loginRec.text!
    }
    
    @IBAction func openRecoveryCodeView(_ sender: UIButton) {
        if sendOneTimeRecoveryCode(phoneNum: loginRec.text) {
           performSegue(withIdentifier: "oneTimeRecoveryCodeSegue", sender: nil)
        } else {
            showMessage(titleStr: "Пользователь не найден", messageStr: "Server error: " + jsonStructure.message! + "; status: " + String(jsonStructure.status))
        }
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
    
    func sendOneTimeRecoveryCode(phoneNum: String!) -> Bool {
        
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "login",
            "value": phoneNum.filter("0123456789".contains),
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = (try? NSData(contentsOfFile:paramSrc, options:[]) as Data)!
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://babasket.com.ua:8088/auth/restore")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else { return }
            do {
                let jsonStr = try JSONDecoder().decode(jsonData.self, from: data)
                self.jsonStructure = jsonStr
            } catch let errorJSON {
                print("Error JSON decode: ", errorJSON)
            }
            
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        if jsonStructure.message!.isEmpty && jsonStructure.status == 0 {
            return true
        } else {
            return false
        }
    }

}

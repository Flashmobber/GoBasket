//
//  oneTimeRecoveryCodeView.swift
//  GoBasket
//
//  Created by Borys on 28.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

class oneTimeRecoveryCodeView: UIViewController, DigitInputViewDelegate {

    struct jsonData: Decodable {
        let data: Int8?
        let message: String?
        let status: Int8
    }

    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var resumeBtn: UIButton!
    
    var jsonStructure: jsonData!
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

        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "login",
            "value": lblPhoneNumber.text!.filter("0123456789".contains),
            "type": "text"
          ],
          [
            "key": "code",
            "value": digitInput.text,
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

        var request = URLRequest(url: URL(string: "https://babasket.com.ua:8088/auth/activate")!,timeoutInterval: Double.infinity)
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
        
        if jsonStructure.status == 0 {
           showMessage(titleStr: "Код принят",
                       messageStr: """
                                   Новый пароль отправлен вам СМС сообщением.
                                   В целях безопасности храните его в надежном месте.
                                   Никому не передавайте свой пароль!!!
                                   """, handler: { action in
                                    self.performSegue(withIdentifier: "unwindToLoginFromORC", sender: nil)
            })
        } else if jsonStructure.status == 20 {
            showMessage(titleStr: "Код не принят", messageStr: "Вы ввели не правильный код." + String(jsonStructure.status), handler: nil)
        } else {
            showMessage(titleStr: "Ошибка!", messageStr: "Error code: " + String(jsonStructure.status), handler: nil)
        }
    }

    func showMessage (titleStr: String!, messageStr: String!, handler: ((UIAlertAction) -> Void)?) {
        let alertWindow = UIAlertController(
        title: titleStr,
        message: messageStr,
        preferredStyle: UIAlertController.Style.alert)
        alertWindow.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: handler))
        alertWindow.view.tintColor = UIColor(named: "#black&white")
        self.present(alertWindow, animated: true, completion: nil)
    }

    
}

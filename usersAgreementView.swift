//
//  usersAgreementView.swift
//  GoBasket
//
//  Created by Borys on 16.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

class usersAgreementView: UIViewController {
    
    @IBOutlet weak var textAgreements: UITextView!
    
    struct jsonData: Decodable{
        let agreement: String
    }
    
    struct jsonAgreement: Decodable {
        
        let data: jsonData
        let message: String
        let status: Int8
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIBarButtonItem(image: UIImage(named:"arrowRight"), style: .plain, target: self, action: #selector(backTapped))
        backBtn.tintColor = UIColor.init(named: "#black&white")
        self.navigationItem.leftBarButtonItem = backBtn
        
        var agreementStr: String = ""
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://babasket.com.ua:8088/agreement")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print("Something wrong when POST agreement was working: "+String(describing: error))
            return
          }
            do {
                let jsonStr = try JSONDecoder().decode(jsonAgreement.self, from: data)
                agreementStr = jsonStr.data.agreement
            } catch let errorJSON {
                print("Error JSON decode: ", errorJSON)
            }
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        do {
            let htmlText = try NSMutableAttributedString(
                  data: agreementStr.data(using: String.Encoding.unicode)!,
                  options: [.documentType: NSAttributedString.DocumentType.html],
                  documentAttributes: nil)
            let attrTxt: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.init(named: "#black&white")!
            ]
            htmlText.addAttributes(attrTxt, range: NSRange(location: 0, length: htmlText.string.count))
            self.textAgreements.attributedText = htmlText
        } catch let error {
            self.textAgreements.attributedText = NSAttributedString(string: "Error: \(error)")
        }
    }
    
    @objc func backTapped() {
        performSegue(withIdentifier: "unwindToLoginScr", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

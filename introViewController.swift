//
//  introViewController.swift
//  GoBasket
//
//  Created by Borys on 30.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

class introViewController: UIViewController {

    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var lblIntroPage: UILabel!
    @IBOutlet weak var btnIntroPage: UIButton!
    @IBOutlet weak var introPageControl: UIPageControl!
    
    var introImageContent: UIImage!
    var introPageText = ""
    let introBtnAttribute = UIButton.init()
    var currentPage = 0
    var numberOgPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introImage.image = introImageContent
        lblIntroPage.text = introPageText
        btnIntroPage.setTitle(introBtnAttribute.titleLabel?.text, for: .normal)
        btnIntroPage.backgroundColor = introBtnAttribute.backgroundColor
        btnIntroPage.setTitleColor(introBtnAttribute.titleColor(for: .normal ), for: .normal)
        introPageControl.numberOfPages = numberOgPages
        introPageControl.currentPage = currentPage

    }
     
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        if let introPVC = storyboard?.instantiateViewController(identifier: "introPageViewController") as? introPageViewController {
            introPVC.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "loginScreenSegue", sender: nil)
         } else {
             print("Error PV dismissed")
         }
    }
    
}

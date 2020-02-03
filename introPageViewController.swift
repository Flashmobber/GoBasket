//
//  introPageViewController.swift
//  GoBasket
//
//  Created by Borys on 30.01.2020.
//  Copyright © 2020 Borys. All rights reserved.
//

import UIKit

extension introPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! introViewController).currentPage
        pageNumber -= 1
        
        return showVCAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var pageNumber = (viewController as! introViewController).currentPage
        pageNumber += 1
        
        return showVCAtIndex(pageNumber)

    }
    
       
}

class introPageViewController: UIPageViewController {

    let introImageContent = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")]

    let introLabelText = [
        "Принимайте и забирайте заказы у наших партнеров",
        "Получите адрес и постройте маршрут к ресторану и клиенту",
        "Вручите товар клиенту и получайте вознаграждения и бонусы за вашу работу!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let introVC = showVCAtIndex(0) {
            setViewControllers([introVC], direction: .forward, animated: true, completion: nil)
        }
    }
        
    func showVCAtIndex(_ index: Int) -> introViewController? {
        
        guard index >= 0 else { return nil }
        guard index < introImageContent.count else { return nil }
        guard let introVC = storyboard?.instantiateViewController(identifier: "introViewController") as? introViewController else { return nil }
        
        introVC.introImageContent = introImageContent[index]!
        introVC.introPageText = introLabelText[index]
        if index == 2 {
            introVC.introBtnAttribute.setTitle("Начать использование", for: .normal)
            introVC.introBtnAttribute.backgroundColor = UIColor.init(named: "#buttonEnable")
            introVC.introBtnAttribute.setTitleColor(UIColor.init(named: "#buttonEnableText"), for: .normal)
        } else {
            introVC.introBtnAttribute.setTitle("Пропустить", for: .normal)
            introVC.introBtnAttribute.backgroundColor = UIColor.init(named: "#view")
            introVC.introBtnAttribute.setTitleColor(UIColor.init(named: "#lightGreyBlue"), for: .normal)
        }
        introVC.currentPage = index
        introVC.numberOgPages = introLabelText.count        
        
        return introVC
    }

}

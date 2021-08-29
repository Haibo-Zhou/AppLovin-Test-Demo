//
//  UIViewController+Ext.swift
//  AppLovin Test Demo
//
//  Created by HaiboZhou on 2021/8/28.
//

import UIKit

extension UIViewController {
    
    func setBackgroundImage(imageName: String) {
        let bgImage = UIImage(named: imageName)
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = bgImage
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}

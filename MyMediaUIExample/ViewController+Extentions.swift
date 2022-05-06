//
//  ViewController+Extentions.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, alertActions: UIAlertAction...) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in alertActions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func openSettingScene() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

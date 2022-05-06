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
    
    
    //클로저를 통해서 함수를 전달받아서 사용하도록 만들 수 있다.
    //escaping -> 외부 함수 안에서 내부함수를 만들고, 내부함수 안에서 다시 함수를 선언하게 되면 밖으로 꺼내올수가 없다.
    //이러한 경우에 밖으로 꺼내기 위해서 escaping 클로저를 사용하게 된다.
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> () ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        //얼럿이 화면에 보여진 직후에 실행될 로직이 있을때 사용할 수 있다.
        self.present(alert, animated: true) {
            print("얼럿이 떴습니다.")
        }
    }
}

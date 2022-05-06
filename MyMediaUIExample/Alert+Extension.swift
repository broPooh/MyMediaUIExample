//
//  Alert+Extension.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/06.
//

import UIKit

extension UIViewController {
    
    func showAlert() {
        
        let alert = UIAlertController(title: "위치 권한 없음", message: "설정으로 이동해주세요", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            print("확인 버튼 눌렀음")
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true) {
            print("얼럿이 떴습니다.")
        }
    }
}

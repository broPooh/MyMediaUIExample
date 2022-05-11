//
//  BaseViewController.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/11.
//

import UIKit
import Network


class BaseViewController: UIViewController {
    var checkNetworkValue = false
    let networkMonitor = NWPathMonitor()


    override func viewDidLoad() {
        super.viewDidLoad()

        startNetworkMonitor()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !checkNetworkValue {
            showAlert(title: "네트워크 연결 상태", message: "네트워크를 연결해주세요", okTitle: "확인", okAction: {
                self.openSettingScene()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopNetworkMonitor()
    }

    func startNetworkMonitor() {
        networkMonitor.start(queue: DispatchQueue.global())
        networkMonitor.pathUpdateHandler = { path in
            self.checkNetworkValue = path.status == .satisfied ? true : false
        }
    }
    
    func stopNetworkMonitor() {
        networkMonitor.cancel()
    }
    
}

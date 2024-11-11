//
//  DelcheckViewController.swift
//  Runner
//
//  Created by Diego Henrique de Abreu on 29/10/24.
//

import Foundation
import delcheck_framework
import UIKit
import Flutter
import SwiftUI

class DelcheckViewController: UIViewController {
    var flutterResult: FlutterResult
//    var arguments: [String: Any]
    
    init(flutterResult:@escaping FlutterResult) {
        self.flutterResult = flutterResult
//        self.arguments = arguments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func start() {
           // Instancia a SwiftUI View e configura o delegate
           var captura = SendMessagingScreen(delegate: self)
           captura.delegate = self // Configura o delegate para receber feedbacks

           // Usa UIHostingController para incorporar a SwiftUI View
           let hostingController = UIHostingController(rootView: captura)
           
           // Adiciona como filho e define o layout
           addChild(hostingController)
           view.addSubview(hostingController.view)
           
           hostingController.view.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
               hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
           
           hostingController.didMove(toParent: self)
           view.backgroundColor = .white
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
           start()
       }
    
}
extension DelcheckViewController: DelcheckViewControllerDelegate {
    func didReceiveSuccess(result: [String: Any]) {
        let response : NSMutableDictionary! = [:]
              response["authorizationId"] = result["authorizationId"]
              response["authorizationCode"] = result["code"]
              flutterResult(response)
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func didReceiveError(error: [String : Any]) {
        let response : NSMutableDictionary! = [:]
                response["code"] = error["codigo"]  as! Int
                response["description"] = error["descricao"]  as! String
                response["id"] = error["id"]  as! String
                flutterResult(response)
        navigationController?.popToRootViewController(animated: false)
    }
}


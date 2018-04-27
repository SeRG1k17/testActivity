//
//  ViewController.swift
//  TestActivity
//
//  Created by Sergey Pugach on 4/3/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import Moya
import Result

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var networking: Networking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func sendButtonDidTapped(_ sender: UIButton) {
        
        textView.text = nil
        networking?.provider.request(.weather(in: "Minsk")) { self.resultHandler($0) }
    }
    
    @IBAction func loginButtonDidTapped(_ sender: UIButton) {
        
        textView.text = nil
        networking?.provider.request(.login(username: "rstolwijk@tandemdiabetes.com", password: "Tandem-1")) { self.resultHandler($0) }
    }
    
    func resultHandler(_ result: Result<Response, MoyaError>) {
        
        switch result {
            
        case .success(let response): self.textView.text = prettyPrint(try! response.mapJSON())
        case .failure(let error): self.textView.text = error.localizedDescription
        }
    }

    //Function to pretty-print Json Object in Swift 3
    func prettyPrint(_ json: Any) -> String {
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let string = String(data: data, encoding: .utf8)!
        return string
    }
}

extension Data {
}


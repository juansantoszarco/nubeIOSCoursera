//
//  ViewController.swift
//  JSZIOSNubeCourseraSemana1
//
//  Created by Juan Antonio de los Santos on 06/05/16.
//  Copyright (c) 2016 Juan Antonio de los Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var resultTextField: UITextView!
    
    @IBAction func selectButton(sender: UIButton) {
        let request = NSString (format: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:%@", inputTextField.text!)
        print(request)
        let url = NSURL (string: request as String)
        let session = NSURLSession.sharedSession()
        let bloque = { (datos : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            let texto = NSString (data : datos!, encoding : NSUTF8StringEncoding)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.resultTextField.text = texto! as String
            })
            
            print(texto!)
        }
        let download = session.dataTaskWithURL(url!, completionHandler:  bloque)
        download.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


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
    
    @IBOutlet weak var resultContainer: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tituloTextField: UILabel!
    
    @IBOutlet weak var autorTextField: UILabel!
    
    @IBOutlet weak var isbnTextField: UILabel!
    
    @IBOutlet weak var paginasTextField: UILabel!
    
    @IBOutlet weak var editorialTextField: UILabel!
    
    @IBOutlet weak var publicacionTextField: UILabel!
    
    @IBAction func selectButton(sender: UIButton) {
        let request = NSString (format: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:%@", inputTextField.text!)
        print(request)
        let url = NSURL (string: request as String)
        let session = NSURLSession.sharedSession()
        let bloque = { (datos : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            let texto = NSString (data : datos!, encoding : NSUTF8StringEncoding)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showResults()
            })
            
            print(texto!)
        }
        let download = session.dataTaskWithURL(url!, completionHandler:  bloque)
        download.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setHidden()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHidden() ->Void {
        resultContainer.hidden = true;
        imageView.hidden = true;
        tituloTextField.hidden = true;
        autorTextField.hidden = true;
        isbnTextField.hidden = true;
        paginasTextField.hidden = true;
        editorialTextField.hidden = true;
        publicacionTextField.hidden = true;
    }
    
    func showResults() -> Void {
        resultContainer.hidden = false;
        imageView.hidden = false;
        tituloTextField.hidden = false;
        autorTextField.hidden = false;
        isbnTextField.hidden = false;
        paginasTextField.hidden = false;
        editorialTextField.hidden = false;
        publicacionTextField.hidden = false;
    }
    
}


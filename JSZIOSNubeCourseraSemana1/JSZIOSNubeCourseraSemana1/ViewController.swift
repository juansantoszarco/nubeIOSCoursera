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
    
    @IBOutlet weak var errorISBN: UILabel!
    
    @IBOutlet weak var resultContainer: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tituloTextField: UILabel!
    
    @IBOutlet weak var autorTextField: UILabel!
    
    @IBOutlet weak var isbnTextField: UILabel!
    
    @IBOutlet weak var paginasTextField: UILabel!
    
    @IBOutlet weak var editorialTextField: UILabel!
    
    @IBOutlet weak var publicacionTextField: UILabel!
    
    @IBAction func selectButton(sender: UIButton) {
        setHidden()
        if Reachability.isConnectedToNetwork() == true {
            startWithSearch()
        } else {
            let alert = UIAlertController(title: "Oops!", message:"No tienes conexión a internet", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default) { _ in
                //Solamente informa, no hago nada más
            }
            alert.addAction(action)
            self.presentViewController(alert, animated: true){}
        }
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
    
    func startWithSearch() -> Void {
        setHidden()
        let request = NSString (format: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:%@", inputTextField.text!)
        let url = NSURL (string: request as String)
        let session = NSURLSession.sharedSession()
        let bloque = { (datos : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            if error != nil {
                print("Error:%@",error)
            }else {
                let texto = NSString (data : datos!, encoding : NSUTF8StringEncoding)
                if texto?.length != 2{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showResults(datos!)
                    })
                }else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.errorISBN.hidden = false
                    })
                }
            }
        }
        let download = session.dataTaskWithURL(url!, completionHandler:  bloque)
        download.resume()
    }
    
    func setHidden() ->Void {
        errorISBN.hidden = true
        resultContainer.hidden = true
        imageView.hidden = true
        tituloTextField.hidden = true
        autorTextField.hidden = true
        isbnTextField.hidden = true
        paginasTextField.hidden = true
        editorialTextField.hidden = true
        publicacionTextField.hidden = true
    }
    
    func showLabels() ->Void {
        resultContainer.hidden = false
        imageView.hidden = false
        tituloTextField.hidden = false
        autorTextField.hidden = false
        isbnTextField.hidden = false
        paginasTextField.hidden = false
        editorialTextField.hidden = false
        publicacionTextField.hidden = false
    }
    
    func showResults(data:NSData) -> Void {
       // let json = convertStringToDictionary(data)
        var error : NSError?
        let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        //println(jsonObject)
        if error == nil{
            if let json = jsonObject as? NSDictionary{
                if let objects = json["ISBN:978-84-376-0494-7"] as? NSDictionary{
                    if let titulo: AnyObject = objects["title"] {
                        tituloTextField.text = "Título: \(titulo)"
                    }
                    
                    isbnTextField.text = NSString (format: "ISBN: %@", inputTextField.text)
                    
                    if let paginas: AnyObject = objects["number_of_pages"] {
                        paginasTextField.text = "Páginas: \(paginas)"
                    }
                    
                    if let authors = objects["authors"] as? NSArray{
                        if let author = authors.objectAtIndex(0) as? NSDictionary{
                            if let nombre: AnyObject = author["name"] {
                                autorTextField.text = "Nombre: \(nombre)"
                            }
                        }
                    }
                    
                    if let publishers = objects["publishers"] as? NSArray{
                        if let publisher = publishers.objectAtIndex(0) as? NSDictionary{
                            if let editorial: AnyObject = publisher["name"] {
                                editorialTextField.text = "Editorial: \(editorial)"
                            }
                        }
                    }
                    
                    if let fecha: AnyObject = objects["publish_date"] {
                        publicacionTextField.text = "Fecha de publicación: \(fecha)"
                    }
                }
            }
        } else {
            println("Error al procesar el JSON")
        }
        
        
        getImageFromUrl()
        
        showLabels()
        
    }
    
    func getImageFromUrl() -> Void {
        
        let request = NSString (format: "http://covers.openlibrary.org/b/isbn/%@.jpg", inputTextField.text!)
        print(request)
        let url = NSURL (string: request as String)
        let session = NSURLSession.sharedSession()
        let bloque = { (datos : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            if error != nil {
                print("Error:%@",error)
            }else {
                let texto = NSString (data : datos!, encoding : NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imageView.contentMode = .ScaleAspectFit
                    self.imageView.image = UIImage (data: datos!)
                })
            }
        }
        let download = session.dataTaskWithURL(url!, completionHandler:  bloque)
        download.resume()
        
        
        
    }

}


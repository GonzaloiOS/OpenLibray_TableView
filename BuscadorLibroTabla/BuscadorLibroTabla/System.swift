//
//  System.swift
//  BuscadorLibroTabla
//
//  Created by Gonzalo on 27/03/16.
//  Copyright © 2016 G. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SystemClassDelegate{
    
    func bookFetched(book:Book)
    func searchBookError(errorString:String)
    
}

class SystemClass{
    
    var delegate:SystemClassDelegate?
    var context:NSManagedObjectContext? = nil
    
    func getDataFromText(isbnCode:String){
        
        var urlString = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urlString += isbnCode
        
        let url = NSURL (string: urlString)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data:NSData?, resp:NSURLResponse?, error:NSError?) -> Void in
            
            var responseToShow:String = ""
            
            if((error) != nil){
                
                responseToShow = "Error en la consulta, revisa tu conexión a internet";
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    self.delegate?.searchBookError(responseToShow)
                    
                })
                
            }else{
                
                let rawResponse:String? = String(data: data!, encoding: NSUTF8StringEncoding)
                
                responseToShow = "Resultado de la búsqueda: " + rawResponse!
                
                if(!(rawResponse! == "{}")){
                    
                    //processing JSON, I have to uwe tray and catch
                    
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                        
                        let jsonDictionary = json as! NSDictionary
                        
                        //let isbnDictionary = jsonDictionary["ISBN:978-84-376-0494-7"] as! NSDictionary
                        let isbnDictionary = jsonDictionary["ISBN:"+isbnCode] as! NSDictionary
                        
                        let titleBook = isbnDictionary["title"] as! NSString as String
                        
                        //let portraitBook = isbnDictionary["url"] as! NSString as String
                        
                        let authorsArray = isbnDictionary["authors"] as! NSArray//iterate array to discover other author names
                        
                        //authorName = subjectPeopleDictionary["name"] as! NSString as String
                        let authorsDictionary = authorsArray[0] as! NSDictionary
                        
                        let authorName = authorsDictionary["name"] as! NSString as String
                        
                        var converDictionary = isbnDictionary["cover"]
                        
                        var coverURL:String? = nil
                        
                        if converDictionary != nil {
                            
                            converDictionary = converDictionary as! NSDictionary
                            coverURL = converDictionary!["medium"] as! NSString as String
                            
                        }
                        
                        let book:Book = Book.init(title: titleBook, author: authorName, imageURL: coverURL, identifierSBNF: isbnCode)
                        
                        if book.imageURL != nil {
                            
                            self.downloadImageWithURL(book)
                        
                        }else{
                            book.image = UIImage(named:"noCover")
                            
                            //core data
                            self.saveBookInCoreData(book)
                            
                            //delegate
                            dispatch_async(dispatch_get_main_queue(),{
                                //show result
                                self.delegate?.bookFetched(book)
                                
                            })
                        }
                    }catch _{
                        
                    }
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        //show result
                        self.delegate?.searchBookError(responseToShow)
                    })
                }
                
            }
        }
        
        task.resume()
        
        //Left to include delegate properties (child)
    }
    
    func downloadImageWithURL(book:Book){
        
        let url = NSURL (string: book.imageURL!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data:NSData?, resp:NSURLResponse?, error:NSError?) -> Void in
        
            if((error) != nil){
                
                book.image = UIImage(named: "noCover")
                
            }else{
                
                book.image = UIImage(data: data!)
            }
            
            self.saveBookInCoreData(book)
            
            dispatch_async(dispatch_get_main_queue(),{
                //show result
                self.delegate?.bookFetched(book)
            })
        }
        
        task.resume()
        
    }
    
    func saveBookInCoreData(book:Book){
        
        if(self.context != nil){
            
        }else{
            
            self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        }
        
        let newBokkInCD = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: self.context!)
        
        newBokkInCD.setValue(book.identifierSBNF, forKey: "identifier")
        newBokkInCD.setValue(book.title!, forKey: "title")
        newBokkInCD.setValue(book.author!, forKey: "author")
        newBokkInCD.setValue(UIImagePNGRepresentation(book.image!), forKey: "coverImage")
        
        do{
            try self.context?.save()
        
        }catch{
            
            print("Error")
        }
        
        
    }
    
}

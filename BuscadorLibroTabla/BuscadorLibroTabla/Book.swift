//
//  Book.swift
//  BuscadorLibroTabla
//
//  Created by Gonzalo on 27/03/16.
//  Copyright © 2016 G. All rights reserved.
//

import UIKit

class Book{
    
    var title:String?
    var author:String?
    var imageURL:String?
    var image:UIImage?
    
    init(title:String, author:String, imageURL:String?){
        
        self.title = title
        self.author = author
        self.imageURL = imageURL
    }

}

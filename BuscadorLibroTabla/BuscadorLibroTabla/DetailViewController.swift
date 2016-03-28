//
//  DetailViewController.swift
//  BuscadorLibroTabla
//
//  Created by Gonzalo on 27/03/16.
//  Copyright © 2016 G. All rights reserved.
//

import UIKit

protocol DetailProtocolDelegate {
    
    func bookSearchedAndAddedToArray(book:Book)
}

class DetailViewController: UIViewController,UITextFieldDelegate,SystemClassDelegate {

    let communication = SystemClass()
    
    @IBOutlet weak var coverBookImageVIew: UIImageView!
    
    @IBOutlet weak var titleBookTextView: UITextView!
    
    @IBOutlet weak var authorTextView: UITextView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate:DetailProtocolDelegate?
    
    var onlyShowBookInfo:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((self.onlyShowBookInfo) != nil){
            
            self.searchTextField.hidden = true;
            self.titleBookTextView.text = self.onlyShowBookInfo!.title!
            self.authorTextView.text = self.onlyShowBookInfo!.author!
            self.coverBookImageVIew.image = self.onlyShowBookInfo!.image
            
        }else{
            
            self.searchTextField.hidden = false;
            self.searchTextField.delegate = self
            self.communication.delegate = self
            
        }
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        print(textField.text!)
        communication.getDataFromText(textField.text!)
        self.searchTextField.resignFirstResponder()
        self.activityIndicator.startAnimating()
        
        return true
    }
    
    func bookFetched(book: Book) {
        
        self.titleBookTextView.text = book.title!
        self.authorTextView.text = book.author!
        self.coverBookImageVIew.image = book.image!
        
        self.delegate?.bookSearchedAndAddedToArray(book)
        
        self.activityIndicator.stopAnimating()
    }
    
    func searchBookError(errorString: String) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        
        actionSheetController.addAction(cancelAction)
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

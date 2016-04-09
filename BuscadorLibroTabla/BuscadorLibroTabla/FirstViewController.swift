//
//  FirstViewController.swift
//  BuscadorLibroTabla
//
//  Created by Gonzalo on 27/03/16.
//  Copyright © 2016 G. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,DetailProtocolDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataToShow:[Book] = []
    var dataToShowDictionary:[String:Book] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.whiteColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.title = "Libros"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(FirstViewController.addTapped))
        // Do any additional setup after loading the view.
    }
    
    func addTapped(){
        
        print("tapped")
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count//change it for array
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("BooksTableViewCell", forIndexPath: indexPath) as! BooksTableViewCell
        let bookk = self.dataToShow[indexPath.row]
        cell.titleBookLabel.text = bookk.title!
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.onlyShowBookInfo = self.dataToShow[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func bookSearchedAndAddedToArray(book: Book) {
        
        if((self.dataToShowDictionary[book.identifierSBNF]) != nil){
            
            
            
        }else{
            
            self.dataToShowDictionary[book.identifierSBNF] = book
            
        }
        
        self.dataToShow = Array(self.dataToShowDictionary.values)
        
        //self.dataToShow.append(book)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
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

//
//  MemeTableViewController.swift
//  MemeMe V.1
//
//  Created by Chi Nguyen on 2017/02/22.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    
    var memes:[Meme]!
    var deleteMemeIndexPath: NSIndexPath? = nil
    let addMemeIdentifer = "MemeEditorViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        //Go straight to editor view if no memes
        if memes.count == 0 {
            performSegue(withIdentifier: addMemeIdentifer, sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == addMemeIdentifer) {
            _ = segue.destination as! MemeEditorViewController
        }
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
//        if editingStyle == .delete {
//            deleteMemeIndexPath = indexPath
//            let memeToDelete = memes[indexPath.row]
//            confirmDelete(Meme: memeToDelete)
//        }
//    }
//    func confirmDelete(Meme: struct;) {
//        let alert = UIAlertController(title: "Delete Meme", message: "Are you sure you want to permanently delete \(Meme)?", preferredStyle: .actionSheet)
//        
//        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteMeme)
//        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteMeme)
//        
//        alert.addAction(DeleteAction)
//        alert.addAction(CancelAction)
//        
//        
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func handleDeleteMeme(alertAction: UIAlertAction!) -> Void {
//        if let indexPath = deleteMemeIndexPath {
//            tableView.beginUpdates()
//            
//            memes.remove(at: indexPath.row)
//            
//            // Note that indexPath is wrapped in an array:  [indexPath]
//            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
//            
//            deleteMemeIndexPath = nil
//            
//            tableView.endUpdates()
//        }
//    }
//    
//    func cancelDeleteMeme(alertAction: UIAlertAction!) {
//        deleteMemeIndexPath = nil
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Configure tableView cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as UITableViewCell!
        let meme = memes[indexPath.row]
        
        cell?.imageView?.image = meme.memedImage
        cell?.textLabel?.text = "\(meme.topTextField) \(meme.bottomTextField)"
        
        return cell!
    }
    //Show detailView from selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController")
        let detailVC = object as! MemeDetailViewController
        
        //pass data from selected row to detail View
        detailVC.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
  
}

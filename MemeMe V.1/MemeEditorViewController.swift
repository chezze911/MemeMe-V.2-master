//
//  MemeEditorViewController.swift
//  MemeMe V.2
//
//  Created by Chi Nguyen on 1/21/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    let memeDelegate = MemeTextFieldDelegate()
    
    var sourceType: UIImagePickerControllerSourceType!
    // set text attributes
    let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.black,
    NSForegroundColorAttributeName : UIColor.white,
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -3.0,
    ] as [String : Any]
    
    func configureTextFields(_ textField: UITextField, text: String) {
        // code to set-up textField behaviors
        textField.text = text
        textField.delegate = memeDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields(topTextField, text:"TOP")
        
        configureTextFields(bottomTextField, text:"BOTTOM")
        
        // source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         //enables camera button only if camera is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        
        //notifies when keyboard appears
        subscribeToKeyboardNotifications()
    }
    func pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    //Tells the delegate that the user picked a still image and sends photo user selected to image viewer and formats to fit
    func imagePickerController(_ sender: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //Keyboard
    //moves frame up when keyboard shows only on bottom text field
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder { // check if text field is currently selected
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0 // (0,0) is the original view location
    }
    //gets keyboard height to move up frame
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    // moves frame back down after moving up keyboard
    
    //notifies when keyboard raises
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    //unsubscribes
    override func viewWillDisappear(_ animated: Bool) {
        //notifies when keyboard disappears
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // create a meme object and add it to the memes array
    func save() {

        let memedImage = generateMemedImage()
        
        //update the meme
        let meme = Meme(topTextField: topTextField.text! as NSString, bottomTextField: bottomTextField.text! as NSString,
                        image: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the AppDelegate
        let object = UIApplication.shared.delegate
        
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        //does same as above code
        //(UIApplication.shared.delegate as!
          //  AppDelegate).memes.append(meme)
    }
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topBar.isHidden = true
        bottomBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topBar.isHidden = false
        bottomBar.isHidden = false
        
        return memedImage
    }

    //share meme
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, completed, returned, error in
            //Allows meme to be saved if activity is completed
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
        
    }
    // clear the text and image
    @IBAction func cancelAction(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text?.removeAll()
        bottomTextField.text?.removeAll()
        viewDidLoad()
    }
}


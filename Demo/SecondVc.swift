//
//  SecondVc.swift
//  Demo
//
//  Created by Soulpage Machintosh 1 on 28/11/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SecondVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()

    @IBAction func backBtAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func addImagesBtrnAction(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
//        {
//            print("Button capture")
//            imagePicker.sourceType = .photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//
//        }
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
        
        //Save image to local device
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("data path",documentsDirectory)
        // choose a name for your image
        let fileName = "editedimage.jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = UIImageJPEGRepresentation(chosenImage, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.isIphoneX {
            view.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - (view.safeAreaInsets.bottom + view.safeAreaInsets.top))
        } else {
            // is not iPhoneX
        }
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if UIDevice.isIphoneX {
//            view.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - (view.safeAreaInsets.bottom + view.safeAreaInsets.top))
//        } else {
//            // is not iPhoneX
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imageView.setRounded()
        if let image = getSavedImage(named: "editedimage.jpg") {
            imageView.image = image
            // do something with image
        }
        runApiService()
        //deleteTheProfilePic()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func deleteTheProfilePic(){
        let fileNameToDelete = "editedimage.jpg"
        var filePath = ""
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        do {
            let fileManager = FileManager.default
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    func runApiService(){
        Alamofire.request("https://api.whitehouse.gov/v1/petitions.json?limit=100", parameters: ["":""], headers: ["":""])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
//
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                   // print("Data: \(utf8Text)") // original server data as UTF8 string
                    do{
                        // Get json data
                        //let json = try JSON(data: data)
                        let jsonString = String(decoding: data, as: UTF8.self)
                        let json = JSON(parseJSON: jsonString)
                        self.parse(json: json)
                    }catch{
                        print("Unexpected error: \(error).")
                    }
                }
        }
    }
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            var title =  result["title"].stringValue
            print("title is ",title)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SignupVC.swift
//  Fashopi
//
//  Created by Soulpage Machintosh 1 on 03/11/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            print("********************")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
//        if(isValidEmail(testStr: "self.usernameTF.text!") == false){
//            let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message:                 NSLocalizedString("FrameWork_Email_Validation", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
//
//               // add an action (button)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("FrameWork_OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true){}
//        }
    }

    @IBAction func signUpAction(_ sender: Any) {
        let alertController = UIAlertController(title: title, message: "message", preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            print("Aleret View Ok Tapped")
            // Put your code here
        })
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backBtnAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}


//
//  ViewController.swift
//  Demo
//
//  Created by Soulpage Machintosh 1 on 27/10/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import UIKit
import Foundation
import Speech
import SwiftyJSON
import SafeAreaExtension
import Photos
import SDWebImage
import SVProgressHUD

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
  
    var dataModel = [Datamodel]()
    var dataSearchList = [Datamodel]()
    var refreshControl = UIRefreshControl()

    
    @IBOutlet weak var searchTextFld: UITextField!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var nameLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "listCustomCell", bundle: bundle)
        listTableView.register(nib, forCellReuseIdentifier: "Cell")
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        self.searchTextFld.delegate = self
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.listTableView.addSubview(refreshControl)
        if ReachabilityTest.isConnectedToNetwork() {
            SVProgressHUD.show()
            callAPIService()
        } else {
            //listTableView.isHidden = true
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
            print("App Version is:",UIApplication.appVersion!)
        }
    }
    @objc func refreshData() {
        if ReachabilityTest.isConnectedToNetwork() {
            callAPIService()
        } else {
            //listTableView.isHidden = true
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
            })
            print("App Version is:",UIApplication.appVersion!)
        }
        // Code to refresh table view
    }
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.isIphoneX {
            view.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - (view.safeAreaInsets.bottom + view.safeAreaInsets.top))
            print("iphone X")
        } else {
            // is not iPhoneX
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callAPIService(){
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        if let url = URL(string: urlString) {
            if let data = try? String(contentsOf: url) {
                let json = JSON(parseJSON: data)
                parse(json: json)
            }
        }
    }
    func parse(json: JSON) {
         dataModel = [Datamodel]()
         dataSearchList = [Datamodel]()
         for result in json["results"].arrayValue {
            var datamodel = Datamodel()
            datamodel.fromJsonToString(result: result)
            dataModel.append(datamodel)
            dataSearchList.append(datamodel)
        }
        listTableView.reloadData()
        SVProgressHUD.dismiss()
        refreshControl.endRefreshing()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :listCustomCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath) as! listCustomCell
        cell.nameLabel.text = dataModel[indexPath.row].title
        cell.countLabel.text = dataModel[indexPath.row].body
        cell.urlLabel.text = dataModel[indexPath.row].url
        let url = URL(string: "https://splashbase.s3.amazonaws.com/unsplash/regular/tumblr_mnh0n9pHJW1st5lhmo1_1280.jpg")!
        cell.sampleImageView.sd_setImage(with: url, placeholderImage:UIImage(named: "download.jpeg"))
        //cell.sampleImageView.downloadedFromurl(url: url)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell text:",self.dataModel[indexPath.row].title)
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        let index = indexPath?.row
        print("index path value is",index!)
        let currentCell = tableView.cellForRow(at: indexPath!) as! listCustomCell
        
        let secondVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVc") as! SecondVc
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if((newString.count) != 0){
            dataModel = [Datamodel]()
            for i in 0 ..< dataSearchList.count{
                if((dataSearchList[i].title.lowercased().contains(newString.lowercased())) || (dataSearchList[i].sigs.contains(newString))){
                    dataModel.append(dataSearchList[i])
                }
            }
            listTableView.reloadData()
            SVProgressHUD.dismiss()
            refreshControl.endRefreshing()
            print("search text:",newString)
        }
        return true
    }
    @IBAction func nextScreenBtnAction(_ sender: Any) {
        refreshControl.endRefreshing()
        let secondVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVc") as! SecondVc
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

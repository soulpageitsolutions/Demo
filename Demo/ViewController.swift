//
//  ViewController.swift
//  Demo
//
//  Created by Soulpage Machintosh 1 on 27/10/18.
//  Copyright © 2018 Soulpage Machintosh 1. All rights reserved.
//

import UIKit
import Speech
import SwiftyJSON

class ViewController: UIViewController {
    var petitions = [[String: String]]()
    
    @IBOutlet weak var nameLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPIService()
        //requestTranscribePermissions()
        print(UIApplication.appVersion!)
        
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
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let url = result["url"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs, "url":url]
            petitions.append(obj)
        }
            print("Response is",petitions)
    }
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    func transcribeAudio(url: URL) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        // start recognition!
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                print(result.bestTranscription.formattedString)
            }
        }
    }
}
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}


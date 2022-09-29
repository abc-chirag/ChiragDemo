//
//  ViewController.swift
//  ChiragDemo
//
//  
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnCompact: UIButton!
    @IBOutlet weak var btnFull: UIButton!
    @IBOutlet weak var btn1min: UIButton!
    @IBOutlet weak var btn5min: UIButton!
    @IBOutlet weak var btn15min: UIButton!
    @IBOutlet weak var btn30min: UIButton!
    @IBOutlet weak var btn60min: UIButton!
    @IBOutlet weak var txtApiKey: UITextField!
    
    var outputSize: String = ""
    var interval: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtApiKey.text = "demo"
        
        outputSize = "full"
        btnCompact.backgroundColor = .white
        btnFull.backgroundColor = .blue
        btnCompact.titleLabel?.textColor = .blue
        btnFull.titleLabel?.textColor = .white
        
        interval = "15min"
        setSelectedBtn(btn: btn15min)
    }
    

    func setSelectedBtn(btn: UIButton) {
        btn1min.backgroundColor = btn == btn1min ? .blue : .white
        btn5min.backgroundColor = btn == btn5min ? .blue : .white
        btn15min.backgroundColor = btn == btn15min ? .blue : .white
        btn30min.backgroundColor = btn == btn30min ? .blue : .white
        btn60min.backgroundColor = btn == btn60min ? .blue : .white
        
        btn1min.titleLabel?.textColor = btn == btn1min ? .white : .blue
        btn5min.titleLabel?.textColor = btn == btn5min ? .white : .blue
        btn15min.titleLabel?.textColor = btn == btn15min ? .white : .blue
        btn30min.titleLabel?.textColor = btn == btn30min ? .white : .blue
        btn60min.titleLabel?.textColor = btn == btn60min ? .white : .blue
    }
    
    @IBAction func onBtnCompare(_ sender: Any) {
        let model = PassModel(apiKey: txtApiKey.text ?? "", outputSize: outputSize, interval: interval)
        _ = self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ReCallData"), object: nil, userInfo: model.toDaict())
    }
    
    struct PassModel {
        var apiKey: String = ""
        var outputSize: String = ""
        var interval: String = ""
        
        func toDaict() -> [String: String] {
            var temp = [String: String]()
            temp["apiKey"] = apiKey
            temp["outputSize"] = outputSize
            temp["interval"] = interval
            return temp
        }
    }
    
    @IBAction func compactClick(_ sender: UIButton) {
        outputSize = "compact"
        btnCompact.backgroundColor = .blue
        btnFull.backgroundColor = .white
        btnCompact.titleLabel?.textColor = .white
        btnFull.titleLabel?.textColor = .blue
    }
    
    @IBAction func fullClick(_ sender: UIButton) {
        outputSize = "full"
        btnCompact.backgroundColor = .white
        btnFull.backgroundColor = .blue
        btnCompact.titleLabel?.textColor = .blue
        btnFull.titleLabel?.textColor = .white
    }
    
    @IBAction func min1Click(_ sender: UIButton) {
        interval = "1min"
        setSelectedBtn(btn: btn1min)
    }
    @IBAction func min5Click(_ sender: UIButton) {
        interval = "5min"
        setSelectedBtn(btn: btn5min)
    }
    @IBAction func min15Click(_ sender: UIButton) {
        interval = "15min"
        setSelectedBtn(btn: btn15min)
    }
    @IBAction func min30Click(_ sender: UIButton) {
        interval = "30min"
        setSelectedBtn(btn: btn30min)
    }
    @IBAction func min60Click(_ sender: UIButton) {
        interval = "60min"
        setSelectedBtn(btn: btn60min)
    }
    
}


//
//  SecondViewController.swift
//  ChiragDemo
//
//
//

import UIKit

enum FilterMode {
    case none
    case DateTime
    case Open
    case High
    case Low
}

class SecondViewController: UIViewController {

    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var txtSymbol: UITextField!
    
    let activityView = UIActivityIndicatorView(style: .large)
    var viewModel = ViewModel()
    var datamodel: TestModel?
    let nibNameId = "DataTableViewCell"
    var filterMod: FilterMode = .none
    var arrFilterTimeSeries: [[Date: DateData]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = .init(apiKey:  "demo", outputSize: "full", interval:  "15min")
        callAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.callAPINoti(notification:)), name: Notification.Name("ReCallData"), object: nil)
    }
    
    func setupTableView() {
        tblData.register(UINib(nibName: nibNameId, bundle: nil), forCellReuseIdentifier: nibNameId)
        tblData.dataSource = self
        tblData.delegate = self
        tblData.reloadData()
    }
    
    func showActivityIndicatory() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func hideActivityIndicatory() {
        activityView.removeFromSuperview()
        activityView.stopAnimating()
    }
    
    @IBAction func onBtnDateTime(_ sender: Any) {
        filterMod = .DateTime
        arrFilterTimeSeries = filterArray()
        tblData.reloadData()
    }
    
    @IBAction func onBtnOpen(_ sender: Any) {
        filterMod = .Open
    }
    
    @IBAction func onBtnHigh(_ sender: Any) {
        filterMod = .High
        arrFilterTimeSeries = filterArray()
        tblData.reloadData()
    }
    
    @IBAction func onBtnLow(_ sender: Any) {
        filterMod = .Low
    }
}

// API calls
extension SecondViewController {
    
    func callAPI() {
        showActivityIndicatory()
        viewModel.getApiData(success: { model in
            self.datamodel = model
            DispatchQueue.main.async { [self] in
                self.hideActivityIndicatory()
                self.txtSymbol.text = datamodel?.metaData?.the2Symbol ?? ""
                self.tblData.reloadData()
            }
        }, fail: { msg in
            DispatchQueue.main.async {
                self.hideActivityIndicatory()
            }
            self.showAlert(withTitle: "Error", withMessage: msg)
        })
    }
    
    @objc func callAPINoti(notification: NSNotification) {
        guard let dict = notification.userInfo as? [String: String] else {
            return
        }
        showActivityIndicatory()
        viewModel.apiKey = dict["apiKey"] ?? ""
        viewModel.outputSize = dict["outputSize"] ?? ""
        viewModel.interval =  dict["interval"] ?? ""
        
        viewModel.getApiData(success: { model in
            self.datamodel = model
            DispatchQueue.main.async { [self] in
                self.hideActivityIndicatory()
                self.txtSymbol.text = datamodel?.metaData?.the2Symbol ?? ""
                self.tblData.reloadData()
            }
        }, fail: { msg in
            DispatchQueue.main.async {
                self.hideActivityIndicatory()
            }
            self.showAlert(withTitle: "Error", withMessage: msg)
        })
    }
}

extension SecondViewController:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterMod == .none {
            return datamodel?.arrTimeSeries?.count ?? 0
        }
        
        return arrFilterTimeSeries?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nibNameId) as? DataTableViewCell else { return .init() }
        if filterMod == .none {
            let arr = datamodel?.arrTimeSeries?[indexPath.row].values.first
            let date = datamodel?.arrTimeSeries?[indexPath.row].keys.first
            cell.lblDateTime.text = date?.description
            cell.lblOpen.text = arr?.the1Open ?? ""
            cell.lblHigh.text = arr?.the2High ?? ""
            cell.lblLow.text = arr?.the3Low ?? ""
        } else {
            let arr = arrFilterTimeSeries?[indexPath.row].values.first
            let date = arrFilterTimeSeries?[indexPath.row].keys.first
            cell.lblDateTime.text = date?.description
            cell.lblOpen.text = arr?.the1Open ?? ""
            cell.lblHigh.text = arr?.the2High ?? ""
            cell.lblLow.text = arr?.the3Low ?? ""
        }
        return cell
    }
    
    
    func filterArray()-> [[Date: DateData]]? {
        guard let arr = datamodel?.arrTimeSeries else {
            return nil
        }
        if filterMod == .DateTime {
            let newarr = arr.sorted(by: { d1, d2 in
                d1.keys.first! > d2.keys.first!
            })
            return newarr
        }
        return nil
    }
    
}

extension  UIViewController {

    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}

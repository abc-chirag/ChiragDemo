//
//  ViewModel.swift
//  ChiragDemo
//
//  
//

import Foundation


enum TimeDuration : String {
    case min1 = "Time Series (1min)"
    case min5 = "Time Series (5min)"
    case min15 = "Time Series (15min)"
    case min30 = "Time Series (30min)"
    case min60 = "Time Series (60min)"
}

class ViewModel {
    
    var apiKey: String = ""
    var outputSize: String = ""
    var interval: String = ""
    private var model: TestModel?
    
    
    init() { }
    
    init(apiKey: String,outputSize: String, interval: String ) {
        self.apiKey = apiKey
        self.outputSize = outputSize
        self.interval = interval
    }
    
    func validate() -> Bool {
        if apiKey == "" || outputSize == "" || interval == "" {
            return false
        }
        return true
    }
    
    func getApiData(success: @escaping ((TestModel)->()),fail: @escaping ((String)->())){
        if !validate() {
            fail("Plz enter valid data.")
        }
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=\(interval)&outputsize=\(outputSize)&apikey=\(apiKey)")!
        print(url.description)
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                fail(error?.localizedDescription ?? "Fail to map Data")
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                let model = self.mapJson(from: jsonString)
                if model.metaData == nil {
                    fail("No Data")
                }
                self.model = model
                success(model)
            } else {
                fail(error?.localizedDescription ?? "Fail to map Data")
            }
            
        }.resume()
    }
    
    func mapJson(from jsonString: String) -> TestModel {
        guard let dict = self.convertStringToDictionary(text: jsonString) else {
            return .init(metaData: nil, timeSeriesTitle: nil, arrTimeSeries: nil)
        }
        
        if let min1 = dict[TimeDuration.min1.rawValue] as? [String: AnyObject] {
            return getFinalModel(dict: dict, minDict: min1)
        }
        
        if let min5 = dict[TimeDuration.min5.rawValue] as? [String: AnyObject] {
            return getFinalModel(dict: dict, minDict: min5)
        }
        
        if let min15 = dict[TimeDuration.min15.rawValue] as? [String: AnyObject] {
            return getFinalModel(dict: dict, minDict: min15)
        }
        
        if let min30 = dict[TimeDuration.min30.rawValue] as? [String: AnyObject] {
            return getFinalModel(dict: dict, minDict: min30)
        }
        
        if let min60 = dict[TimeDuration.min60.rawValue] as? [String: AnyObject] {
            return getFinalModel(dict: dict, minDict: min60)
        }
        
        return .init(metaData: nil, timeSeriesTitle: nil, arrTimeSeries: nil)
    }
    
    func getFinalModel(dict:[String: AnyObject],minDict: [String: AnyObject]) -> TestModel {
        let metaData = dict["Meta Data"] as! [String: String]
        var newarray = [[Date: DateData]]()
        
        for i in minDict {
            //                print(i.key)
            //                print(i.value)
            let date = getDate(strDate: i.key)
            newarray.append([ date : DateData(the1Open: i.value["1. open"] as? String,
                                              the2High: i.value["2. high"] as? String,
                                              the3Low: i.value["3. low"] as? String,
                                              the4Close: i.value["4. close"] as? String,
                                              the5Volume: i.value["5. volume"] as? String)])
        }
        
        let metadata = MetaData(the1Information: metaData["1. Information"],
                                the2Symbol: metaData["2. Symbol"],
                                the3LastRefreshed: metaData["3. Last Refreshed"],
                                the4Interval: metaData["4. Interval"],
                                the5OutputSize: metaData["5. Output Size"],
                                the6TimeZone: metaData["6. Time Zone"])
        let timedue = TimeDuration.min15
        return TestModel(metaData: metadata, timeSeriesTitle: timedue, arrTimeSeries: newarray)
    }
    
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func getDate(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: strDate)!
    }
}

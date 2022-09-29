//
//  TestModel.swift
//  ChiragDemo
//
//  
//

import Foundation

struct TestModel {
    var metaData: MetaData?
    var timeSeriesTitle: TimeDuration?
    var arrTimeSeries: [[Date: DateData]]?
}

struct MetaData {
    var the1Information, the2Symbol, the3LastRefreshed, the4Interval: String?
    var the5OutputSize, the6TimeZone: String?
}

struct DateData {
    var the1Open, the2High, the3Low, the4Close: String?
    var the5Volume: String?
}

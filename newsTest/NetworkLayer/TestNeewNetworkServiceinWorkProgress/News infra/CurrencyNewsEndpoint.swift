//
//  CurrencyNewsEndpoint.swift
//  newsTest
//
//  Created by алексей ганзицкий on 24.10.2023.
//

import Foundation

class CurencyNewsEndpoint: Endpoint {
    var baseURLResolver: BaseURLResolver
    var path: String
    var method: Method
    let apiKey = "bd4291cebed94b898dd76406d634bac2"
    
    init(baseURLResolver: BaseURLResolver, path: String, method: Method) {
        self.baseURLResolver = baseURLResolver
        self.path = path
        self.method = method
    }
    
    private func createParamsForRequest(theme: String, keyAPI: String, page: Int) -> [String: String] {
        let pageToString = String(page)
        let dateForNewsToday = convertDateToString(day: .today)
        let dateForNewsYesterday = convertDateToString(day: .yesterday)
        
        let URLParams = [
            "q": theme,
            "status": "ok",
            "language": "en",
            "pageSize": "20",
            "page": pageToString,
            "from": dateForNewsYesterday,
            "to": dateForNewsToday,
            "sortBy": "popularity",
            "apiKey": keyAPI
        ]
        return URLParams
    }
    
    private enum Days {
        case today
        case yesterday
    }
    // доработать работу с месяццами
    private func convertDateToString(day: Days) -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        var dayCurrent = formatter.string(from: date as Date)
        dayCurrent.insert("-", at: dayCurrent.startIndex)
        let theDayBefore = "\(Int(dayCurrent)! + 2 )"
        formatter.dateFormat = "yyyy-MM"
        let newYearAndMonth = formatter.string(from: date as Date)
        switch day {
        case .today :
            let dateForNews = newYearAndMonth + dayCurrent
            return dateForNews
        case .yesterday:
            let dateForNews = newYearAndMonth + theDayBefore
            return dateForNews
        }
    }
}

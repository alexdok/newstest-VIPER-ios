//
//  NetworkManager.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import UIKit

protocol NetworkService {
    func loadNews( theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void)
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void)
}

final class NetworkServiceImpl: NetworkService {
    
    private let mapper: MapNewsToObject
    private let requestBilder: RequestBuilder
    lazy var cacheDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        cache.countLimit = 50
        return cache
    }()
    
    init(mapper: MapNewsToObject, requestBilder: RequestBuilder) {
        self.mapper = mapper
        self.requestBilder = requestBilder
    }
    
    func loadNews(theme: String, page: Int, completion: @escaping ([ObjectNewsData?]) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let URLParams = createParamsForRequest(theme: theme, keyAPI: Constants.apiKey, page: page)
        guard let request = requestBilder.createRequestFrom(url: Constants.url, params: URLParams, httpMethod: Method.get.rawValue) else { return }
       
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                do {
                    let news = try JSONDecoder().decode(News.self, from: data)
                    let objectNews = self.filterObjectNews(news: news)
                    completion(objectNews)
                } catch {
                    print(error.localizedDescription)
                    completion([nil])
                }
            }
        }
        task.resume()
//        session.finishTasksAndInvalidate()
    }
    
    func loadImage(urlForImage: String, completion: @escaping (UIImage) -> Void) {
        if let image = cacheDataSource.object(forKey: urlForImage as AnyObject) {
            // Изображение найдено в кэше
            completion(image)
        } else {
            downloadImageFromURL(urlForImage: urlForImage, completion: completion)
        }
    }
    
    private func downloadImageFromURL(urlForImage: String, completion: @escaping (UIImage) -> Void) {
        guard let urlImage = URL(string: urlForImage) else {
            // Если URL недействителен, возвращаем дефолтное изображение
            completion(returnDefaultImage())
            return
        }
        
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: urlImage, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 3)
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error as? URLError, error.code == .timedOut {
                // Если запрос превысил таймаут, возвращаем дефолтное изображение
                completion(returnDefaultImage())
            } else if let data = data, let image = UIImage(data: data) {
                // Если нет ошибки и удалось получить изображение из данных, то возвращаем его
                self.compressAndCacheImage(image, forKey: urlForImage)
                completion(image)
            } else {
                // Если что-то пошло не так, возвращаем дефолтное изображение
                completion(returnDefaultImage())
            }
        }
        task.resume()
    }
    
    private func filterObjectNews(news: News) -> [ObjectNewsData] {
        let objectNews = mapper.map(news)
        var objectNewsFinish = [ObjectNewsData]()
        objectNews.forEach {
            if $0.title != nil {
                objectNewsFinish.append($0)
            }
        }
        return objectNewsFinish
    }
    
    private func returnDefaultImage() -> UIImage {
        if let defaultImage = UIImage(named: "noImage") {
            return defaultImage
        }
        return UIImage()
    }
    
    private func compressAndCacheImage(_ image: UIImage, forKey key: String) {
        let compressedImage = image.jpegData(compressionQuality: 0.1)
        
        if let data = compressedImage, let compressedImage = UIImage(data: data) {
            cacheDataSource.setObject(compressedImage, forKey: key as AnyObject)
        }
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
        //    "apiKey": keyAPI
        ]
        return URLParams
    }
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

private extension NetworkServiceImpl {
    enum Constants {
        static let url = "https://newsapi.org/v2/everything"
        static let apiKey = "bd4291cebed94b898dd76406d634bac2"
        //bd4291cebed94b898dd76406d634bac2
        //90253efc2978411a9214e198e3374178
    }
}


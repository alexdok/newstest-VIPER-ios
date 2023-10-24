//
//  MapNewsToObject.swift
//  newsTest
//
//  Created by алексей ганзицкий on 30.08.2023.
//

import Foundation

protocol MapNewsToObject {
    func map(_ news: News) -> [ObjectNewsData]
}

struct MapNewsToObjectImpl: MapNewsToObject {
    func map(_ news: News) -> [ObjectNewsData] {
        var newObjectNewsArraay: [ObjectNewsData] = []
        for items in news.articles {
            let objectNews = ObjectNewsData(author: items.author,
                                            title: items.title,
                                            description: items.description,
                                            url: items.url,
                                            urlToImage: items.urlToImage,
                                            publishedAt: items.publishedAt,
                                            content: items.content)
                newObjectNewsArraay.append(objectNews)
        }
        return newObjectNewsArraay
    }
}


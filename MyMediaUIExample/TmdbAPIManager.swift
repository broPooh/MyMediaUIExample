//
//  TmdbAPIManager.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/10.
//

import Foundation
import Alamofire
import SwiftyJSON

class TmdbAPIManager {
    static let shared = TmdbAPIManager()
    
    func fetchTrendingTmdbData(mediaType: TrendingMediaType, windowType: TrendingWindowType, page: Int, result: @escaping (Int, [TmdbTrendingData], Int) -> () ) {
        AF.request(Const.EndPoint.tmdbTranding(mediaType: mediaType, windowType: windowType, page: page), method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let statusCode = response.response?.statusCode ?? 500
                
                let results = json["results"].arrayValue
                let totalPage = json["total_pages"].intValue
                let trendingDatas: [TmdbTrendingData] = results.map { json in
                    let title = json["title"].stringValue
                    let overview = json["overview"].stringValue
                    let releaseDate = json["release_date"].stringValue
                    let posterPath = Const.EndPoint.tmdbImageUrl(imagePath: json["poster_path"].stringValue)
                    let backdropPath = Const.EndPoint.tmdbImageUrl(imagePath: json["backdrop_path"].stringValue)
                    
                    let genreIds: [Int] = json["genre_ids"].arrayValue.map { genreJson in
                        return genreJson.intValue
                    }
                    
                    let voteAverage = json["voteAverage"].stringValue
                    
                    return TmdbTrendingData(title: title, overview: overview, releaseDate: releaseDate, posterPath: posterPath, backdropPath: backdropPath, genreIds: genreIds, voteAverage: voteAverage)
                }
                                
                result(statusCode, trendingDatas, totalPage)
                
                                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  Enums.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/10.
//

import Foundation
import MapKit

enum TrendingMediaType: String {
    case all = "all"
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}

enum TrendingWindowType: String {
    case day = "day"
    case week = "week"
}

enum CreditType: String {
    case cast = "cast"
    case crew = "crew"
}


enum TheaterEnum: String, CaseIterable {
    case megaBox = "메가박스"
    case lotteCinema = "롯데시네마"
    case cgv = "CGV"
    case all = "ALL"
        
    func theaterAnnotation() -> [MKPointAnnotation] {
        switch self {
        case .megaBox, .lotteCinema, .cgv, .all:
            return buildTypeMapAnnotation(type: rawValue)
        }
    }
    
    func buildTypeMapAnnotation(type: String) -> [MKPointAnnotation] {
        
        if type == TheaterEnum.all.rawValue {
            return TheaterLocationInformation().mapAnnotations.map { theaterLocation in
                //핀 추가(어노테이션)
                let annotation = MKPointAnnotation()
                annotation.title = theaterLocation.location
                annotation.coordinate = CLLocationCoordinate2D(latitude: theaterLocation.latitude, longitude: theaterLocation.longitude)
                return annotation
            }
        } else {
            return TheaterLocationInformation().mapAnnotations.filter { theaterLocation in
                theaterLocation.type == type
            }.map { theaterLocation in
                //핀 추가(어노테이션)
                let annotation = MKPointAnnotation()
                annotation.title = theaterLocation.location
                annotation.coordinate = CLLocationCoordinate2D(latitude: theaterLocation.latitude, longitude: theaterLocation.longitude)
                return annotation
            }
        }

    }
}

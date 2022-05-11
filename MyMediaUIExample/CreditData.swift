//
//  CreditData.swift
//  MyMediaUIExample
//
//  Created by bro on 2022/05/10.
//

import Foundation

struct CreditData {
    let id: Int
    let casts: [Cast]
    let crews: [Crew]
}

struct Cast {
    let name: String
    let profilePath: String?
    let character: String
}

struct Crew {
    let name: String
    let profilePath: String?
    let job: String
}

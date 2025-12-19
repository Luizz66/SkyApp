//
//  GeocodingData.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 12/12/25.
//

import Foundation

struct GeocodingData: Codable {
    let name: String
    let local_names: Pt
}

struct Pt: Codable {
    let pt: String
}


//
//  Font.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 11/12/25.
//

import SwiftUI

extension Font {
    static func comicNeue(size: CGFloat, weight: fontWeight? = nil) -> Font {
        switch weight {
        case .light:
            return .custom("ComicNeue-Light", size: size)
        case .regular:
            return .custom("ComicNeue-Regular", size: size)
        case .bold:
            return .custom("ComicNeue-Bold", size: size)
        default:
            return .custom("ComicNeue-Bold", size: size)
        }
    }
}

enum fontWeight {
    case light
    case regular
    case bold
}

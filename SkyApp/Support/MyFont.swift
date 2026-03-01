//
//  MyFont.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 11/12/25.
//

import SwiftUI

extension Font {
    static func myFont(style: Font.TextStyle, weight: fontWeight? = nil) -> Font {
        let fontName: String
        
        switch weight ?? .bold {
        case .light: fontName = "ComicNeue-Light"
        case .regular: fontName = "ComicNeue-Regular"
        case .bold: fontName = "ComicNeue-Bold"
        }
        
        return .custom(fontName, size: baseSize(for: style), relativeTo: style)
    }
    
    static func myFont(size: CGFloat, weight: fontWeight? = nil) -> Font {
        
        let fontName: String
        
        switch weight ?? .bold {
        case .light: fontName = "ComicNeue-Light"
        case .regular: fontName = "ComicNeue-Regular"
        case .bold: fontName = "ComicNeue-Bold"
        }
        
        return .custom(fontName, size: size)
    }
    
    //pega o valor base para retornar o style correto
    private static func baseSize(for style: Font.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 17
        }
    }
}

enum fontWeight {
    case light
    case regular
    case bold
}

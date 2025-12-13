//
//  OverlayStyle.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 13/12/25.
//

import SwiftUI

//🌤️ Day – Clouds
//RGB: 201, 218, 244
//HEX: #C9DAF4
//🔹 Azul claro bem suave, levemente frio, ótimo para fundo neutro de dia nublado.
//🌧️ Day – Rain
//RGB: 162, 176, 211
//HEX: #A2B0D3
//🔹 Azul acinzentado, clima mais fechado/triste, perfeito para chuva.
//❄️ Day – Snow
//RGB: 191, 203, 214
//HEX: #BFCCD6
//🔹 Cinza-azulado muito claro, sensação de frio e neve, quase branco.
//☀️ Day – Clear
//RGB: 206, 221, 254
//HEX: #CEDDFE
//🔹 Azul céu limpo, mais vibrante e alegre, ótimo para tempo aberto.
//🌙 Night – Clouds
//RGB: 41, 63, 119
//HEX: #293F77
//🔹 Azul profundo noturno, excelente para modo escuro e céu à noite.

//🖼️ Night - Rain
//(tons bem escuros, azul profundo)
//HEX: #0F1C33
//RGB: 15, 28, 51
//➡️ Azul quase preto, bem noturno e pesado.

//🖼️ Night - Snow
//(azul mais claro, bastante neblina / neve)
//HEX: #5E6F95
//RGB: 94, 111, 149
//➡️ Azul frio acinzentado, sensação de inverno.

//🖼️ Night - Clear
//(azul mais limpo e saturado)
//HEX: #1F4F85
//RGB: 31, 79, 133

//FALTA: night-rain, night-snow, night GPT

//PROMPT: se eu mandar umas imagens aqui, você consegue me mandar a cor media delas? tipo quando você colocar um blur na imagem e as cores se misturam, mas quero uma imagem única solida para que essa cor possa "se misturar" na imagem

extension Color {
    static func overlayStyle(icon: String) -> Color {
        switch icon {
        case "01d", "02d":
            return Color(.colorDay)
        case "03d", "04d", "50d":
            return Color(.colorDayCloud)
        case "09d", "10d", "11d":
            return Color(.colorDayRain)
        case "01n", "02n":
            return Color(.colorNight)
        case "03n", "04n", "50n":
            return Color(.colorNightCloud)
        case "09n", "10n", "11n":
            return Color(.colorNightRain)
        case "13d":
            return Color(.colorDaySnow)
        case "13n":
            return Color(.colorNightSnow)
        default:
            return Color(.gray.opacity(0.5))
        }
    }
}

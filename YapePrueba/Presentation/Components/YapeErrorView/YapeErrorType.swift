//
//  YapeErrorType.swift
//  YapePrueba
//
//  Created by iMac on 17/07/24.
//

import Foundation
import SwiftUI

enum typeReturn {
    case tryAgain
    case close
}

enum YapeErrorType: Error, LocalizedError {
    case emptyView
    case error404
    case timeOut
    case noInternetConnection
    case error400
    case error403
    case error405
    case error504
    
    var errorTitle: String? {
        switch self {
        case .emptyView:
            return "Estamos consiguiendo los mejores beneficios"
        case .error404:
            return "La URL solicitada no se encuentra en este servidor."
        case .timeOut:
            return "Tiempo de espera Terminado"
        case .noInternetConnection:
            return "Sin conexión a internet"
        case .error400:
            return "Ups esto es vergonzoso algo inesperado ha ocurrido"
        case .error403:
            return "Tu sesión ha finalizado"
        case .error405:
            return "Ups esto es vergonzoso algo inesperado ha ocurrido"
        case .error504:
            return "Ups, hubo un problema con el servidor"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .emptyView:
            return "Nuestro equipo sigue trabajando para entregarte los mejores descuentos."
        case .error404:
            return nil
        case .timeOut:
            return "Te invitamos a encontrar otros beneficios"
        case .noInternetConnection:
            return "Revisa:\n • Si estás conectado a una red wifi\n • Comprueba que tengas encendido los datos moviles"
        case .error400:
            return nil
        case .error403:
            return "No tienes permiso para ver estos contenidos"
        case .error405:
            return nil
        case .error504:
            return nil
        }
    }
    
    var errorImage: Image {
        switch self {
        case .emptyView:
            return ConstantsUi.Images.iconDiscountEmpty
        case .error404:
            return ConstantsUi.Images.iconError404
        case .timeOut:
            return ConstantsUi.Images.iconErrorNoInternetConnection
        case .noInternetConnection:
            return ConstantsUi.Images.iconErrorNoInternetConnection
        case .error400, .error405:
            return ConstantsUi.Images.IconError400
        case .error403, .error504:
            return ConstantsUi.Images.iconError403
        }
    }
    
    var buttonTitle: String? {
        switch self {
        case .emptyView:
            return "Volver atras"
        case .error404, .timeOut:
            return "Volver atras"
        case .noInternetConnection , .error400, .error405 , .error504:
            return "Vuelve a intentarlo"
        case .error403:
            return "Inicia sesión nuevamente"
        }
    }
    
    var typeReturn: typeReturn {
        switch self {
        case .emptyView, .error404, .timeOut, .error403:
            return .close
        case .noInternetConnection , .error400, .error405 , .error504:
            return .tryAgain
        }
    }
}

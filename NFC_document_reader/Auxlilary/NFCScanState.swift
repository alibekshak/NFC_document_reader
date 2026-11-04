//
//  NFCScanState.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 20.10.2026.
//

import Foundation

import Foundation

enum NFCScanState: Equatable {
    case waitingDocument
    case connecting
    case authenticating
    case readingDocument
    case documentReady
    case failed
    
    var image: String {
        switch self {
        case .waitingDocument:
            "wave.3.right.circle"
            
        case .connecting:
            "iphone.radiowaves.left.and.right"
            
        case .authenticating:
            "lock.shield"
            
        case .readingDocument:
            "doc.text.magnifyingglass"
            
        case .documentReady:
            "checkmark.circle.fill"
            
        case .failed:
            "exclamationmark.triangle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .waitingDocument:
            "Поднесите документ"
            
        case .connecting:
            "Подключаемся"
            
        case .authenticating:
            "Проверяем документ"
            
        case .readingDocument:
            "Считываем данные"
            
        case .documentReady:
            "Документ считан"
            
        case .failed:
            "Не удалось прочитать документ"
        }
    }
    
    var description: String {
        switch self {
        case .waitingDocument:
            "Поднесите верхнюю часть iPhone к NFC-чипу документа."
            
        case .connecting:
            "Устанавливаем соединение с NFC-чипом."
            
        case .authenticating:
            "Выполняем защищённое подключение к документу."
            
        case .readingDocument:
            "Не убирайте документ и держите iPhone неподвижно."
            
        case .documentReady:
            "Данные документа успешно получены."
            
        case .failed:
            "Попробуйте приложить документ ещё раз."
        }
    }
    
    var showsProgress: Bool {
        switch self {
        case .connecting,
                .authenticating,
                .readingDocument:
            true
            
        case .waitingDocument,
                .documentReady,
                .failed:
            false
        }
    }
    
    var canClose: Bool {
        switch self {
        case .waitingDocument,
                .documentReady,
                .failed:
            true
            
        case .connecting,
                .authenticating,
                .readingDocument:
            false
        }
    }
}

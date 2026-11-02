//
//  NFCScanState.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 20.10.2026.
//

import Foundation

enum NFCScanState {
    case waitingDocument
    case connecting
    case readingDocument
    case documentReady
    
    
    var image: String {
        switch self {
        case .waitingDocument:
            "wave.3.right.circle"
            
        case .readingDocument:
            "iphone.radiowaves.left.and.right"
            
        case .connecting:
            "doc.text.magnifyingglass"
            
        case .documentReady:
            "checkmark.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .waitingDocument:
            "Поднесите документ"

        case .connecting:
            "Документ найден"

        case .readingDocument:
            "Считываем данные"

        case .documentReady:
            "Документ считан"
        }
    }
    
    var description: String {
        switch self {
        case .waitingDocument:
            "Поднесите верхнюю часть iPhone к NFC-чипу документа."
            
        case .readingDocument:
            "Не убирайте документ и держите iPhone неподвижно."
            
        case .connecting:
            "Проверяем и обрабатываем полученные данные."
            
        case .documentReady:
            "Данные документа успешно получены."
        }
    }
    
    var showsProgress: Bool {
        switch self {
        case .connecting, .readingDocument:
            true
            
        case .waitingDocument, .documentReady:
            false
        }
    }
}

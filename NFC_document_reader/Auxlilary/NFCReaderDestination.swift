//
//  NFCReaderDestination.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 04.11.2026.
//

import Foundation

enum NFCReaderDestination: Identifiable {
    case scanning
    case document(PassportDocumentModel)
    
    var id: String {
        switch self {
        case .scanning:
            "scanning"
            
        case .document:
            "document"
        }
    }
}

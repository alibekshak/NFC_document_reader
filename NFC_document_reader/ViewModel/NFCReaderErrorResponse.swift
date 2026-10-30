//
//  NFCReaderErrorResponse.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 30.10.2026.
//

import Foundation

enum NFCReaderErrorResponse: LocalizedError {
    case statusWord(sw1: UInt8, sw2: UInt8)
    case unsupportedTag
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case let .statusWord(sw1, sw2):
            String(
                format: "APDU error: %02X %02X",
                sw1,
                sw2
            )
            
        case .unsupportedTag:
            "Unsupported NFC tag"
            
        case .connectionFailed:
            "Failed to connect to NFC tag"
        }
    }
}

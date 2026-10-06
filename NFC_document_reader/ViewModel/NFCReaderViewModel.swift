//
//  NFCReaderViewModel.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 28.09.2026.
//

import Foundation
import Observation
import CoreNFC

@Observable
final class NFCReaderViewModel: NSObject {
    var message: String = ""
    
    private var session: NFCNDEFReaderSession?
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            message = "NFC недоступен на этом устройстве"
            return
        }
        
        session = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: true
        )
        
        session?.alertMessage = "Поднесите iPhone к NFC-метке"
        session?.begin()
    }
    
}

// MARK: - NFCNDEFReaderSessionDelegate

extension NFCReaderViewModel: NFCNDEFReaderSessionDelegate {
    func readerSession(
        _ session: NFCNDEFReaderSession,
        didInvalidateWithError error: Error
    ) {
        print("NFC session ended:", error)
    }
    
    func readerSession(
        _ session: NFCNDEFReaderSession,
        didDetectNDEFs messages: [NFCNDEFMessage]
    ) {
        guard
            let record = messages.first?.records.first,
            let text = String(data: record.payload, encoding: .utf8)
        else {
            return
        }
        
        Task { @MainActor in
            self.message = text
        }
    }
}

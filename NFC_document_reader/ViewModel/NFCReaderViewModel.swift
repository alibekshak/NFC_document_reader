//
//  NFCReaderViewModel.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 28.09.2026.
//

import CoreNFC
import Foundation
import Observation
import CoreNFC

@Observable
final class NFCReaderViewModel: NSObject {
    var message: String = ""
    var isScanPresented = false
    var scanState: NFCScanState = .waitingDocument
    
    private var session: NFCNDEFReaderSession?
    
    func startScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            message = "NFC недоступен на этом устройстве"
            return
        }
        
        isScanPresented = true
        scanState = .waitingDocument
        
        session = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: true
        )
        
        session?.alertMessage = "Поднесите iPhone к документу"
        session?.begin()
    }
    
    func closeScanning() {
        session?.invalidate()
        session = nil
        isScanPresented = false
    }
}

// MARK: - NFCNDEFReaderSessionDelegate

extension NFCReaderViewModel: NFCNDEFReaderSessionDelegate {
    func readerSessionDidBecomeActive(
        _ session: NFCNDEFReaderSession
    ) {
        Task { @MainActor in
            self.scanState = .waitingDocument
        }
    }
    
    func readerSession(
        _ session: NFCNDEFReaderSession,
        didDetectNDEFs messages: [NFCNDEFMessage]
    ) {
        Task { @MainActor in
            self.scanState = .scanningDocument
        }
        
        guard let message = messages.first else {
            Task { @MainActor in
                self.message = "Данные NFC не найдены"
                self.scanState = .waitingDocument
            }
            return
        }
        
        let records = message.records
        
        guard let record = records.first else {
            Task { @MainActor in
                self.message = "NFC запись отсутствует"
                self.scanState = .waitingDocument
            }
            return
        }
        
        Task { @MainActor in
            self.scanState = .loading
        }
        
        let payload = record.payload
        
        let text = String(
            data: payload,
            encoding: .utf8
        ) ?? "Не удалось прочитать данные"
        
        Task { @MainActor in
            self.message = text
            self.scanState = .showDocument
        }
    }
    
    func readerSession(
        _ session: NFCNDEFReaderSession,
        didInvalidateWithError error: any Error
    ) {
        let nfcError = error as? NFCReaderError
        
        switch nfcError?.code {
        case .readerSessionInvalidationErrorUserCanceled:
            Task { @MainActor in
                self.session = nil
                self.isScanPresented = false
            }
            
        case .readerSessionInvalidationErrorSessionTimeout:
            Task { @MainActor in
                self.session = nil
                self.message = "Время сканирования истекло"
                self.isScanPresented = false
            }
            
        default:
            Task { @MainActor in
                self.session = nil
                self.message = error.localizedDescription
                self.isScanPresented = false
            }
        }
    }
}

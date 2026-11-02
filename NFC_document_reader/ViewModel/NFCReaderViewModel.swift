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
    
    private var session: NFCTagReaderSession?
    
    func startScanning() {
        guard NFCTagReaderSession.readingAvailable else {
            message = "NFC недоступен на этом устройстве"
            return
        }
        
        isScanPresented = true
        scanState = .waitingDocument
        
        session = NFCTagReaderSession(
            pollingOption: [.iso14443],
            delegate: self,
            queue: nil
        )
        
        session?.alertMessage = "Поднесите iPhone к NFC-чипу документа"
        session?.begin()
    }
    
    func closeScanning() {
        session?.invalidate()
        session = nil
        isScanPresented = false
    }
}

// MARK: - NFCTagReaderSessionDelegate

extension NFCReaderViewModel: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(
        _ session: NFCTagReaderSession
    ) {
        Task { @MainActor in
            self.scanState = .waitingDocument
        }
    }
    
    func tagReaderSession(
        _ session: NFCTagReaderSession,
        didInvalidateWithError error: any Error
    ) {
        let nfcError = error as? NFCReaderError
        
        Task { @MainActor in
            self.session = nil
            
            switch nfcError?.code {
            case .readerSessionInvalidationErrorUserCanceled:
                self.isScanPresented = false
                
            case .readerSessionInvalidationErrorSessionTimeout:
                self.message = "Время сканирования истекло"
                self.isScanPresented = false
                
            default:
                self.message = error.localizedDescription
                self.isScanPresented = false
            }
        }
    }
    
    func tagReaderSession(
        _ session: NFCTagReaderSession,
        didDetect tags: [NFCTag]
    ) {
        guard tags.count == 1 else {
            session.alertMessage = "Обнаружено несколько NFC-меток"
            session.restartPolling()
            return
        }
        
        guard let tag = tags.first else {
            session.restartPolling()
            return
        }
        
        guard case let .iso7816(iso7816Tag) = tag else {
            session.alertMessage = "Этот NFC-чип не поддерживается"
            session.restartPolling()
            return
        }
        
        Task { @MainActor in
            self.scanState = .connecting
        }
        
        session.connect(to: tag) { [weak self] error in
            guard let self else {
                return
            }
            
            if let error {
                session.alertMessage = "Не удалось подключиться к документу"
                
                Task { @MainActor in
                    self.message = error.localizedDescription
                    self.scanState = .waitingDocument
                }
                
                session.restartPolling()
                return
            }
            
            Task { @MainActor in
                self.scanState = .readingDocument
            }
            
            Task {
                await self.readDocument(
                    tag: iso7816Tag,
                    session: session
                )
            }
        }
    }
}

// MARK: - Document reader

private extension NFCReaderViewModel {
    func readDocument(
        tag: NFCISO7816Tag,
        session: NFCTagReaderSession
    ) async {
        do {
            try await selectPassportApplication(tag: tag)
            
            await MainActor.run {
                message = "Passport application selected"
                scanState = .documentReady
            }
            
            session.alertMessage = "Документ найден"
            
            
        } catch {
            await MainActor.run {
                message = error.localizedDescription
                scanState = .waitingDocument
            }
            
            session.alertMessage = "Не удалось прочитать документ"
            session.restartPolling()
        }
    }
}

// MARK: - SELECT AID

private extension NFCReaderViewModel {
    func selectPassportApplication(
        tag: NFCISO7816Tag
    ) async throws {
        let aid = Data([
            0xA0,
            0x00,
            0x00,
            0x02,
            0x47,
            0x10,
            0x01
        ])
        
        let apdu = NFCISO7816APDU(
            instructionClass: 0x00,
            instructionCode: 0xA4,
            p1Parameter: 0x04,
            p2Parameter: 0x0C,
            data: aid,
            expectedResponseLength: 256
        )
        
        let (_, sw1, sw2) = try await tag.sendCommand(apdu: apdu)
        
        guard sw1 == 0x90, sw2 == 0x00 else {
            throw NFCReaderErrorResponse.statusWord(
                sw1: sw1,
                sw2: sw2
            )
        }
    }
}

//
//  NFCReaderViewModel.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 28.09.2026.
//

import CoreNFC
import Foundation
import Observation

@Observable
final class NFCReaderViewModel: NSObject {
    var message: String = ""
    var destination: NFCReaderDestination?
    var scanState: NFCScanState = .waitingDocument
    private var didFinishSuccessfully = false
    
    private var session: NFCTagReaderSession?
    
    func startScanning() {
        guard NFCTagReaderSession.readingAvailable else {
            message = "NFC недоступен на этом устройстве"
            return
        }
        
        didFinishSuccessfully = false
        message = ""
        scanState = .waitingDocument
        destination = .scanning
        
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
        destination = nil
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
            
            if self.didFinishSuccessfully {
                self.didFinishSuccessfully = false
                return
            }
            
            switch nfcError?.code {
            case .readerSessionInvalidationErrorUserCanceled:
                self.destination = nil
                
            case .readerSessionInvalidationErrorSessionTimeout:
                self.message = "Время сканирования истекло"
                self.scanState = .failed
                self.destination = nil
                
            default:
                self.message = error.localizedDescription
                self.scanState = .failed
                self.destination = nil
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
                self.scanState = .authenticating
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
            guard tag.initialSelectedAID.uppercased()
                    == "A0000002471001"
            else {
                throw NFCReaderErrorResponse.unsupportedTag
            }
            
            await MainActor.run {
                message = "Passport application selected"
                scanState = .readingDocument
            }
            
            // Mock
            let document = PassportDocumentModel.mock

            await MainActor.run {
                self.didFinishSuccessfully = true
                self.scanState = .documentReady
                self.destination = .document(document)
            }

            session.alertMessage = "Документ успешно считан"

            session.invalidate()
            
        } catch {
            await MainActor.run {
                message = error.localizedDescription
                scanState = .failed
            }
            
            session.invalidate(
                errorMessage: "Не удалось прочитать документ"
            )
        }
    }
}

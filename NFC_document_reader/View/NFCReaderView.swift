//
//  NFCReaderView.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 28.09.2026.
//

import SwiftUI

struct NFCReaderView: View {
    @State private var nfcReaderViewModel = NFCReaderViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(nfcReaderViewModel.message)
            
            Button("Scan NFC") {
                nfcReaderViewModel.startScanning()
            }
        }
        .sheet(
            item: $nfcReaderViewModel.destination
        ) { destination in
            sheetContent(destination)
        }
    }
    
    @ViewBuilder
    private func sheetContent(
        _ destination: NFCReaderDestination
    ) -> some View {
        switch destination {
        case .scanning:
            NFCScanningView(
                state: nfcReaderViewModel.scanState,
                onClose: {
                    nfcReaderViewModel.closeScanning()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(
                !nfcReaderViewModel.scanState.canClose
            )
            
        case let .document(document):
            PassportDocumentView(
                document: document
            )
            .presentationDetents([.large])
        }
    }
}

#Preview {
    NFCReaderView()
}

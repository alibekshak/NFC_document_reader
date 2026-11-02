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
        .sheet(isPresented: $nfcReaderViewModel.isScanPresented) {
            NFCScanningView(
                state: nfcReaderViewModel.scanState,
                onClose: {
                    nfcReaderViewModel.closeScanning()
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled(
                nfcReaderViewModel.scanState == .readingDocument
                || nfcReaderViewModel.scanState == .connecting
            )
        }
    }
}

#Preview {
    NFCReaderView()
}

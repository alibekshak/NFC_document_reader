//
//  NFCReaderView.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 28.09.2026.
//

import SwiftUI

struct NFCReaderView: View {
    @State private var nfcReader = NFCReaderViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(nfcReader.message)
            
            Button("Scan NFC") {
                nfcReader.startScanning()
            }
        }
    }
}

#Preview {
    NFCReaderView()
}

//
//  NFCScanningView.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 21.10.2026.
//

import SwiftUI

struct NFCScanningView: View {
    let state: NFCScanState
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                
                if state != .readingDocument && state != .connecting {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: state.image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            VStack(spacing: 8) {
                Text(state.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(state.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if state.showsProgress {
                ProgressView()
            }
            
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    NFCScanningView(
        state: .connecting,
        onClose: {}
    )
}

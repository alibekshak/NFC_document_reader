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
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: 32, height: 32)
                }
            }
            
            Spacer()
            
            image
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if showsProgress {
                ProgressView()
            }
            
            Spacer()
        }
        .padding(24)
    }
    
    @ViewBuilder
    private var image: some View {
        switch state {
        case .waitingDocument:
            Image(systemName: "wave.3.right.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
        case .scanningDocument:
            Image(systemName: "iphone.radiowaves.left.and.right")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
        case .loading:
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
        case .showDocument:
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
        }
    }
    
    private var title: String {
        switch state {
        case .waitingDocument:
            "Поднесите документ"
            
        case .scanningDocument:
            "Считываем документ"
            
        case .loading:
            "Обрабатываем данные"
            
        case .showDocument:
            "Документ считан"
        }
    }
    
    private var description: String {
        switch state {
        case .waitingDocument:
            "Поднесите верхнюю часть iPhone к NFC-чипу документа."
            
        case .scanningDocument:
            "Не убирайте документ и держите iPhone неподвижно."
            
        case .loading:
            "Проверяем и обрабатываем полученные данные."
            
        case .showDocument:
            "Данные документа успешно получены."
        }
    }
    
    private var showsProgress: Bool {
        switch state {
        case .scanningDocument, .loading:
            true
            
        case .waitingDocument, .showDocument:
            false
        }
    }
}

#Preview {
    NFCScanningView(
        state: .loading,
        onClose: {
        })
}

//
//  PassportDocumentView.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 04.11.2026.
//

import SwiftUI

struct PassportDocumentView: View {
    let document: PassportDocumentModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if let image = document.faceImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 150)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            }
            
            documentInfo
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var documentInfo: some View {
        VStack(spacing: 16) {
            infoRow(
                title: "Document number",
                value: document.documentNumber
            )
            
            infoRow(
                title: "Nationality",
                value: document.nationality
            )
            
            infoRow(
                title: "Date of birth",
                value: document.dateOfBirthText
            )
            
            infoRow(
                title: "Expiry date",
                value: document.expiryDateText
            )
            
            infoRow(
                title: "Document type",
                value: document.documentType
            )
        }
    }
    
    private func infoRow(
        title: String,
        value: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    PassportDocumentView(document: .mock)
}

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
        VStack(alignment: .leading, spacing: 16) {
            if let image = document.faceImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 150)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            }
            
            Text(document.fullName)
                .font(.title2.bold())
            
            LabeledContent(
                "Document number",
                value: document.documentNumber
            )
            
            LabeledContent(
                "Nationality",
                value: document.nationality
            )
            
            LabeledContent(
                "Date of birth",
                value: document.dateOfBirthText
            )
            
            LabeledContent(
                "Sex",
                value: document.sex
            )
            
            LabeledContent(
                "Expiry date",
                value: document.expiryDateText
            )
            
            LabeledContent(
                "Issuing state",
                value: document.issuingState
            )
            
            LabeledContent(
                "Document type",
                value: document.documentType
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    PassportDocumentView(document: .mock)
}

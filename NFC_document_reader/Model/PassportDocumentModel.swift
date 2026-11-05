//
//  PassportDocumentModel.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 04.11.2026.
//

import SwiftUI

struct PassportDocumentModel: Identifiable {
    let id = UUID()
    
    let documentType: String
    let issuingState: String
    let surname: String
    let givenNames: String
    let documentNumber: String
    let nationality: String
    let dateOfBirth: Date?
    let sex: String
    let expiryDate: Date?
    let faceImage: UIImage?

    var fullName: String {
        [givenNames, surname]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    var dateOfBirthText: String {
        dateOfBirth?.formatted(
            .dateTime
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
        ) ?? "—"
    }

    var expiryDateText: String {
        expiryDate?.formatted(
            .dateTime
                .day(.twoDigits)
                .month(.twoDigits)
                .year()
        ) ?? "—"
    }
}

// MARK: - Mock data

extension PassportDocumentModel {
    static let mock: PassportDocumentModel = .init(
        documentType: "P",
        issuingState: "KAZ",
        surname: "TEST",
        givenNames: "SOME_NAME",
        documentNumber: "N12345678",
        nationality: "KAZ",
        dateOfBirth: Calendar.current.date(
            from: DateComponents(
                year: 1900,
                month: 1,
                day: 1
            )
        ),
        sex: "M",
        expiryDate: Calendar.current.date(
            from: DateComponents(
                year: 2035,
                month: 1,
                day: 1
            )
        ),
        faceImage: UIImage(systemName: "person.crop.rectangle")
    )
}

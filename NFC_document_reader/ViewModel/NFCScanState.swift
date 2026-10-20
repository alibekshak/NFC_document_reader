//
//  NFCScanState.swift
//  NFC_document_reader
//
//  Created by Alibek Shakirov on 20.10.2026.
//

import Foundation

enum NFCScanState {
    case waitingDocument
    case scanningDocument
    case loading
    case showDocument
}

//
//  Item.swift
//  EquiPay
//
//  Created by Christofher Ontiveros Espino on 01/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

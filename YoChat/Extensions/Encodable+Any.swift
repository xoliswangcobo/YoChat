//
//  Encodable+Any.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

extension Encodable {
    static func encode<T: Encodable>(decoded:T?) throws -> Any? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom({ date, encoder in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = ServiceEnvironment.commonDateFormat
                var container = encoder.singleValueContainer()
                try container.encode(dateFormatter.string(from: date))
            })
            let encoded = try encoder.encode(decoded)
            return try JSONSerialization.jsonObject(with:encoded, options: [])
        } catch let error {
            throw error
        }
    }
}

//
//  Logger.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/07/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//
import SwiftUI

struct Logger {
    static func log(_ message: String) {
        let timeStamp: String = DateFormatter.localizedString(from: Date(),
                                                              dateStyle: .short,
                                                              timeStyle: .medium)
        print("------------------------------")
        print("[\(timeStamp)]")
        print(message)
    }
}

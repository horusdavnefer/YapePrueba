//
//  Url+Extension.swift
//  YapePrueba
//
//  Created by iMac on 18/07/24.
//

import Foundation

extension URL {
    static func getUrl(from string: String?) -> URL? {
        return URL(string: string ?? "")
    }
}

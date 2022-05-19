//
//  Currency.swift
//  Curversion2
//
//  Created by Glorio on 18/05/22.
//

import Foundation
import Alamofire

struct Symbols: Codable {
    var success: Bool
    var symbols = [String: Symbol]()
}

struct Symbol: Codable {
    var description: String
    var code: String
}

struct Conversion: Codable {
    var success: Bool
    var result: Double
    var info: Rate
}

struct Rate: Codable {
    var rate: Double
}

func getSymbols(url: String, completion: @escaping (Symbols) -> ()) {
    Session.default.request(url).responseDecodable(of: Symbols.self) { response in
        switch response.result {
        case .success(let symbols):
            print(symbols)
            completion(symbols)
        case .failure(let error):
            print(error)
        }
    }
}

func getConversionResult(url: String, completion: @escaping (Conversion) -> ()) {
    Session.default.request(url).responseDecodable(of: Conversion.self) { response in
        switch response.result {
        case .success(let convert):
            print(convert)
            completion(convert)
        case .failure(let error):
            print(error)
        }
    }
}

//
//  MIError.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import Foundation
enum MIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
    case invalidEmail
    case missingFields
}

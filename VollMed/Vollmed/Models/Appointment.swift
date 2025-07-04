//
//  Appointment.swift
//  Vollmed
//
//  Created by Maria Clara Dias on 04/07/25.
//

import Foundation

struct Appointment: Identifiable, Codable {
    let id: String
    let date: String
    let specialist: Specialist
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "data"
        case specialist = "especialista"
    }
}

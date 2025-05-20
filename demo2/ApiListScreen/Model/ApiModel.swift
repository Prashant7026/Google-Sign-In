//
//  ApiModel.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation

struct ApiModel: Codable {
    let id: String
    var name: String
    var data: DataClass?
}

struct DataClass: Codable {
    var dataColor, dataCapacity: String?
    var capacityGB: Int?
    var dataPrice: Double?
    var dataGeneration: String?
    var year: Int?
    var cpuModel, hardDiskSize, strapColour, caseSize: String?
    var color, description, capacity: String?
    var screenSize: Double?
    var generation, price: String?

    enum CodingKeys: String, CodingKey {
        case dataColor = "color"
        case dataCapacity = "capacity"
        case capacityGB = "capacity GB"
        case dataPrice = "price"
        case dataGeneration = "generation"
        case year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case color = "Color"
        case description = "Description"
        case capacity = "Capacity"
        case screenSize = "Screen size"
        case generation = "Generation"
        case price = "Price"
    }
}

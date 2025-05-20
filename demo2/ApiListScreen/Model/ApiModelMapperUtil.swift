//
//  ApiModelMapperUtil.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation

class ApiModelMapperUtil {
    static func apiEnitityToApiModel(apiEntities: [ApiEntity]) -> [ApiModel] {
        var apiModelArr: [ApiModel] = []
        
        for apiEntity in apiEntities {
            let apiModel = ApiModel(
                id: apiEntity.id ?? "",
                name: apiEntity.name ?? "",
                data: dataClassEntityToDataClass(classEntity: apiEntity.data)
            )
            
            apiModelArr.append(apiModel)
        }
        
        return apiModelArr
    }
    
    static func dataClassEntityToDataClass(classEntity: DataClassEntity?) -> DataClass? {
        guard let classEntity = classEntity else { return nil }
        
        let dataClass = DataClass(
            dataColor: classEntity.dataColor,
            dataCapacity: classEntity.dataCapacity,
            capacityGB: Int(classEntity.capacityGB),
            dataPrice: classEntity.dataPrice,
            dataGeneration: classEntity.dataGeneration,
            year: Int(classEntity.year),
            cpuModel: classEntity.cpuModel,
            hardDiskSize: classEntity.hardDiskSize,
            strapColour: classEntity.strapColour,
            caseSize: classEntity.caseSize,
            color: classEntity.color,
            description: classEntity.desc,
            capacity: classEntity.capacity,
            screenSize: classEntity.screenSize,
            generation: classEntity.generation,
            price: classEntity.price
        )
        
        return dataClass
    }
}

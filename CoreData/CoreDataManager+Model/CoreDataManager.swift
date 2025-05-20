//
//  CoreDataManager.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    // Persistent container for managing the Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save changes to Core Data
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

extension CoreDataManager {
    func saveTask(apiModels: [ApiModel]) {
        self.deleteAllData()
        
        let container = ApiContainerEntity(context: context)
        
        for apiModel in apiModels {
            let apiEntity = ApiEntity(context: context)
            let dataEntity = DataClassEntity(context: context)
            
            apiEntity.id = apiModel.id
            apiEntity.name = apiModel.name
            
            if let capacityGB = apiModel.data?.capacityGB {
                dataEntity.capacityGB = Int16(capacityGB)
            }
            if let dataPrice = apiModel.data?.dataPrice {
                dataEntity.dataPrice = dataPrice
            }
            if let screenSize = apiModel.data?.screenSize {
                dataEntity.screenSize = screenSize
            }
            if let year = apiModel.data?.year {
                dataEntity.year = Int16(year)
            }
            dataEntity.capacity = apiModel.data?.capacity
            dataEntity.caseSize = apiModel.data?.caseSize
            dataEntity.color = apiModel.data?.color
            dataEntity.cpuModel = apiModel.data?.cpuModel
            dataEntity.dataCapacity = apiModel.data?.dataCapacity
            dataEntity.dataColor = apiModel.data?.dataColor
            dataEntity.dataGeneration = apiModel.data?.dataGeneration
            dataEntity.desc = apiModel.data?.description
            dataEntity.generation = apiModel.data?.generation
            dataEntity.hardDiskSize = apiModel.data?.hardDiskSize
            dataEntity.price = apiModel.data?.price
            dataEntity.strapColour = apiModel.data?.strapColour
            
            apiEntity.data = dataEntity
            container.addToApiEntities(apiEntity)
        }
        
        saveContext()
    }
    
    func fetchTasks() -> [ApiEntity] {
        let fetchRequest: NSFetchRequest<ApiEntity> = ApiEntity.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func deleteTask(task: ApiEntity) {
        CoreDataManager.shared.context.delete(task)
        CoreDataManager.shared.saveContext()
    }
    
    func deleteAllData() {
        let entities = ["ApiContainerEntity", "ApiEntity", "DataClassEntity"]
        
        for entityName in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
            } catch {
                print("Failed to delete all objects for entity \(entityName): \(error)")
            }
        }
        
        do {
            try context.save()
            context.reset() // Clear cached objects in context
            print("Deleted all data successfully.")
        } catch {
            print("Failed to save context after deletion: \(error)")
        }
    }
}

extension CoreDataManager {
    func saveUserDetails(_ userDetail: UserDetailModel) {
        let container = UserDetailEntity(context: context)
        
        container.name = userDetail.name
        container.email = userDetail.email
        
        saveContext()
    }
    
    func getUserDetails() -> UserDetailEntity? {
        let fetchRequest: NSFetchRequest<UserDetailEntity> = UserDetailEntity.fetchRequest()

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch tasks: \(error)")
            return nil
        }
    }
}

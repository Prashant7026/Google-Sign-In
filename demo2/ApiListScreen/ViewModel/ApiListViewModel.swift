//
//  ApiListViewModel.swift
//  demo2
//
//  Created by Prashant Kumar Soni on 19/05/25.
//

import Foundation
import UserNotifications

class ApiListViewModel: ObservableObject {
    @Published var apiData: [ApiModel]?
    @Published var isLoading: Bool = false
    @Published var isNotificationEnabled = false
    
    func fetchApiIfNeeded() {
        isLoading = true
        if !AppUserDefaults.isApiCalled {
            apiCall()
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let fetchedData = CoreDataManager.shared.fetchTasks()
                DispatchQueue.main.async {
                    self.apiData = ApiModelMapperUtil.apiEnitityToApiModel(apiEntities: fetchedData)
                }
            }
        }
        isLoading = false
    }
    
    func editData(_ editedData: ApiModel) {
        DispatchQueue.global(qos: .userInitiated).async {
            CoreDataManager.shared.editData(with: editedData)
        }
    }
    
    func deleteCell(index: Int) {
        let deletedModel = self.apiData?[index]
        self.apiData?.remove(at: index)
        let storedData = CoreDataManager.shared.fetchTasks()
        CoreDataManager.shared.deleteTask(task: storedData[index])
        if let model = deletedModel {
            self.scheduleNotification(deletedModel: model)
        }
    }
    
    func scheduleNotification(deletedModel: ApiModel) {
        let content = UNMutableNotificationContent()
        content.title = "Delete Item"
        content.body = deletedModel.name
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    private func apiCall () {
        Task {
            await ListService.apiCall { (result: Result<[ApiModel], DataError>) in
                switch result {
                case .success(let success):
                    CoreDataManager.shared.saveTask(apiModels: success)
                    self.apiData = success
                    AppUserDefaults.isApiCalled = true
                case .failure(_):
                    print("Error in calling api")
                }
            }
        }
    }
}

extension ApiListViewModel {
    func permissionForNotification() {
        if isNotificationEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                guard let welf = self else { return }
                
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                    welf.isNotificationEnabled = false
                }
            }
        } else {
            print("Notification off")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
}

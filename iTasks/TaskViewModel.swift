//
//  TaskViewModel.swift
//  iTasks
//
//  Created by Nihaal Garud on 20/08/2024.
//

import Foundation
import SwiftUI
import Cocoa

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    @Published var completedTasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private let tasksKey = "tasks"
    
    init() {
        loadTasks()
    }
    
    func addTask(title: String, notes: String) {
        let newTask = Task(title: title, notes: notes)
        tasks.append(newTask)
    }
    
    func completeTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var completedTask = tasks.remove(at: index)
            completedTask.isCompleted = true
            completedTasks.append(completedTask)
        }
    }
    
    func editTask(_ task: Task, newTitle: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].title = newTitle
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
    
    private func saveTasks() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let savedTasksData = UserDefaults.standard.data(forKey: tasksKey) {
            let decoder = JSONDecoder()
            if let loadedTasks = try? decoder.decode([Task].self, from: savedTasksData) {
                tasks = loadedTasks
            }
        }
    }
}

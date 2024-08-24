import SwiftUI

@main
struct iTasksApp: App {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

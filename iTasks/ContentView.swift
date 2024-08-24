import SwiftUI
import Cocoa

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var notes: String = ""  // Default empty string for notes
}

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    @State private var newNotes: String = ""

    var body: some View {
        VStack {
            HStack {
                Image("iTasksLogo")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.leading, 2)
                TextField("Enter new task", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onSubmit {
                        viewModel.addTask(title: newTaskTitle, notes: newNotes)
                    }
                Button(action: {
                    viewModel.addTask(title: newTaskTitle, notes: newNotes)
                    newTaskTitle = ""
                }) {
                    Text("Add")
                }
                .padding()
            }

            List {
                Section(header: Text("Tasks")) {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                                .onTapGesture {
                                    viewModel.completeTask(task)
                                }
                            Image(systemName: "note.text")
                                .onTapGesture {
                                    openNotesWindow(for: task)
                                }
                            
                            Text(task.title)
                            Spacer()
                        }
                        .contextMenu {
                            Button("Edit") {
                                editTask(task)
                            }
                            Button("Delete") {
                                viewModel.deleteTask(task)
                            }
                        }
                    }
                }

                Section(header: Text("Completed Tasks")) {
                    ForEach(viewModel.completedTasks) { task in
                        Text(task.title)
                            .strikethrough()
                    }
                }
            }
            
        }
        .padding()
    }

    private func editTask(_ task: Task) {
        let alert = NSAlert()
        alert.messageText = "Edit Task"
        alert.informativeText = "Edit the title of the task."
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")

        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.stringValue = task.title
        alert.accessoryView = textField

        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            viewModel.editTask(task, newTitle: textField.stringValue)
        }
    }
    
    private func openNotesWindow(for task: Task) {
        let notesView = NotesView(task: task) // Pass the task directly

        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered, defer: false)

        newWindow.contentView = NSHostingView(rootView: notesView)
        newWindow.title = task.title
        newWindow.makeKeyAndOrderFront(nil)
    }
}

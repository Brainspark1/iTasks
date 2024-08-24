//
//  TimerView.swift
//  iTasks
//
//  Created by Nihaal Garud on 20/08/2024.
//

import Foundation
import SwiftUI
import Combine

struct TimerView: View {
    @State private var hours: String = "0"
    @State private var minutes: String = "0"
    @State private var seconds: String = "0"
    @State private var timer: AnyCancellable?
    @State private var remainingTime: Int = 0
    @State private var isRunning: Bool = false
    
    private var totalSeconds: Int {
        let h = Int(hours) ?? 0
        let m = Int(minutes) ?? 0
        let s = Int(seconds) ?? 0
        return (h * 3600) + (m * 60) + s
    }
    
    var body: some View {
            HStack {
                Text(timeString(from: remainingTime))
                    .font(.system(size: 20))
                    .padding()
                TextField("Hours", text: $hours)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                
                TextField("Minutes", text: $minutes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)

                TextField("Seconds", text: $seconds)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
                Button(action: startTimer) {
                    Text(isRunning ? "Pause" : "Start")
                }
                .padding()
                
                Button(action: resetTimer) {
                    Text("Reset")
                }
            }
            .padding()
    }
    
    private func startTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimerCountdown()
        }
    }
    
    private func startTimerCountdown() {
        remainingTime = totalSeconds
        isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timer?.cancel()
                    isRunning = false
                }
            }
    }
    
    private func pauseTimer() {
        timer?.cancel()
        isRunning = false
    }
    
    private func resetTimer() {
        timer?.cancel()
        isRunning = false
        remainingTime = 0
        hours = "0"
        minutes = "0"
        seconds = "0"
    }
    
    private func timeString(from time: Int) -> String {
        let h = time / 3600
        let m = (time % 3600) / 60
        let s = time % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}

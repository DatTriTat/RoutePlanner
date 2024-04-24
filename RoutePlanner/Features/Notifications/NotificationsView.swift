import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.trips) { trip in
                Text("\(trip.title) on \(trip.startDate.formatted())")
            }
            .navigationTitle("Trip Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schedule All Notifications") {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        scheduleNotifications()
                    }
                }
            }
            .onAppear {
                requestNotificationPermission()
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification Permission Granted")
            } else {
                print("Notification Permission Denied")
                if let error = error {
                    print("Notification Error: \(error.localizedDescription)")
                }
            }
        }
    }

    private func scheduleNotifications() {
        for trip in viewModel.trips {
            print(trip.title)
            let daysUntilTrip = Calendar.current.dateComponents([.day], from: Date(), to: trip.startDate).day ?? 0
            if daysUntilTrip == 1 { 
                scheduleNotification(for: trip)
            }
        }
    }

    private func scheduleNotification(for trip: Trip) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder: \(trip.title)"
        content.body = "Your trip to \(trip.title) is tomorrow!"
        content.sound = UNNotificationSound.default

        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: trip.startDate)
        dateComponents.hour = 10

        if let triggerDate = calendar.date(from: dateComponents) {
            let timeInterval = triggerDate.timeIntervalSinceNow
            if timeInterval > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for \(trip.title) at \(trip.startDate)")
                    }
                }
            }
        }
    }
}

import Foundation

// Protocol ini yang akan dipakai oleh ViewModel, 
// sehingga ViewModel tidak peduli apakah device pakai CoreHaptics atau Fallback.
protocol HapticFeedbackProviding {
    func prepare()
    func playHaptic(for urgency: AlertUrgency)
    func stop()
}
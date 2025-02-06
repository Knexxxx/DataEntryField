
import SwiftUI
import Combine

class KeyboardEventBus {
    static let shared = KeyboardEventBus() // Singleton instance
    
    let keyTapped = PassthroughSubject<String, Never>() // Publishes key taps
    
    private init() {} // Private initializer to enforce singleton pattern
}

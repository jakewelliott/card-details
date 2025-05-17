//
//  BiometricHelper.swift
//  CardDetails
//
//  Created by Jake Elliott on 5/9/25.
//

import LocalAuthentication

class BiometricAuth: ObservableObject {
    @Published var isUnlocked = false
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to view sensitive card details"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    self.isUnlocked = success
                }
            }
        }
    }
}

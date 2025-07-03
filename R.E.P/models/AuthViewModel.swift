import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let authManager = FirebaseAuthManager.shared
    
    init() {
        authManager.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAuthenticated)
        authManager.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoading)
        authManager.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
    }
    
    func signIn(email: String, password: String) async throws {
        try await authManager.signIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws {
        try await authManager.signUp(email: email, password: password)
    }
    
    func registerUser(email: String, password: String) async throws {
        try await authManager.signUp(email: email, password: password)
    }
    
    func signOut() {
        do {
            try authManager.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
} 
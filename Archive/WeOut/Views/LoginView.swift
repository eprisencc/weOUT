//
//  LoginView.swift
//  WeOut
//
//  Created by Jonathan Loving on 5/21/24.
//

import AuthenticationServices
import GoogleSignInSwift
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift



struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var profileVm: ProfileViewModel
@State private var showTripsView = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                Image("loginScreen")
                    .foregroundStyle(Color(.blue))
                    .padding()
                Spacer()

                VStack{
                    Text("User Id: \(String(describing: Auth.auth().currentUser?.uid))")
                    
                    if let user = profileVm.user{
                        Text(user.email)
                            .foregroundStyle(.black)
                        Text(user.name)
                            .foregroundStyle(.black)
                    }
                    
                    Button("Signout"){
                        do {
 try Auth.auth().signOut()

                        } catch{
                            
                        }
                    }
                }
                // MARK: - Apple
                SignInWithAppleButton(
                    onRequest: { request in
                        AppleSignInManager.shared.requestAppleAuthorization(request)
                    },
                    onCompletion: { result in
                        
                        handleAppleID(result)
//                        showTripsView.toggle()
                    }
                )
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .frame(width: 280, height: 45, alignment: .center)
                .padding(.bottom, 50)

                // MARK: - Google
                /*GoogleSignInButton {
                    Task {
                        await signInWithGoogle()
                    }
                }*/
                //.frame(width: 280, height: 45, alignment: .center)

                // MARK: - Anonymous
                // Hide `Skip` button if user is anonymous.
                /*if authManager.authState == .signedOut {
                    Button {
                        signAnonymously()
                    } label: {
                        Text("Skip")
                            .font(.body.bold())
                            .frame(width: 280, height: 45, alignment: .center)
                    }
                }*/
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "2DC7FF"))
            .ignoresSafeArea()
            .onAppear{
//                if profileVm.user != nil {
//                    showTripsView = true
//                    print("Login Succeful")
//                }
                
                Task{
                    try await profileVm.loadCurrentUser()
                    let authUser = try? AuthManager.shared.getAuthUser()
//                    showTripsView = (authUser != nil)
                    
                    
                }
            }
        }.refreshable {
            Task{
                try? await profileVm.loadCurrentUser()
            }}
        .fullScreenCover(isPresented: $showTripsView) {
            TripsView()
        }
    }

    /// Sign in with `Google`, and authenticate with `Firebase`.
    /*func signInWithGoogle() async {
        do {
            guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }

            let result = try await authManager.googleAuth(user)
            if let result = result {
                print("GoogleSignInSuccess: \(result.user.uid)")
                dismiss()
            }
        }
        catch {
            print("GoogleSignInError: failed to sign in with Google, \(error))")
            // Here you can show error message to user.
            return
        }
    }*/

    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }

            Task {
                do {
                    let result = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    )
                    
                    
                    if let authResult = result {
                                       // Send user data to Firestore
                                       try await sendUserDataToFirestore(authResult.user)
                                       
                                       // Dismiss view or perform any other necessary actions
                                       dismiss()
                                   }
                     if result != nil {
                        dismiss()
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                    // Here you can show error message to user.
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }
    
    func sendUserDataToFirestore(_ user: User) async throws {
        // Your code for sending user data to Firestore collection
        // Assuming you have access to Firestore and 'authManager'
        // This might be similar to the logic you use elsewhere to send user data to Firestore
        let db = Firestore.firestore()
        if let currentUser = Auth.auth().currentUser {
            let usersCollection = db.collection("users")
            let userData: [String: Any] = [
                "uid": currentUser.uid,
                "email": currentUser.email ?? "",
                "name": currentUser.displayName ?? ""
                // Add other user data fields as needed
            ]
            // Add the user data to Firestore
            try await usersCollection.document(currentUser.uid).setData(userData)
        }
    }

    /// Sign-in anonymously
    /*func signAnonymously() {
        Task {
            do {
                let result = try await authManager.signInAnonymously()
                print("SignInAnonymouslySuccess: \(result?.user.uid ?? "N/A")")
            }
            catch {
                print("SignInAnonymouslyError: \(error)")
            }
        }
    }*/
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
        .environmentObject(ProfileViewModel())

}

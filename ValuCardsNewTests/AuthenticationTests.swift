//
//  AuthenticationTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 17/10/2023.
//

import XCTest
@testable import ValuCards

final class AuthenticationTests: XCTestCase {
    
    var authManager: AuthenticationProtocol!
    
    override func setUp() {
        super.setUp()
        authManager = AuthenticationMock()
    }
    
    override func tearDown() {
        authManager = nil
        super.tearDown()
    }
    
    func testSignInWithFirebase() {
        let expectation = self.expectation(description: "Sign in with Firebase")
        
        (authManager as? AuthenticationMock)?.signInWithFirebaseError = nil
        
        authManager.signInWithFirebase(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success():
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got \(error) instead")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSignUpWithFirebase() {
        let expectation = self.expectation(description: "Sign up with Firebase")
        
        (authManager as? AuthenticationMock)?.signUpWithFirebaseError = nil
        
        authManager.signUpWithFirebase(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success():
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got \(error) instead")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSignInWithFirebaseFailure() {
        let expectation = self.expectation(description: "Failed to sign in with Firebase")
        
        (authManager as? AuthenticationMock)?.signInWithFirebaseError = .firebaseLoginError
        
        authManager.signInWithFirebase(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success():
                XCTFail("Expected failure, but got success instead")
            case .failure(let error as ErrorCase):
                XCTAssertEqual(error, .firebaseLoginError)
                XCTAssertEqual(error.message, "Firebase login issue. Retry later")
                expectation.fulfill()
            default:
                XCTFail("Unexpected error type")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSignUpWithFirebaseFailure() {
        let expectation = self.expectation(description: "Failed to sign up with Firebase")
        
        (authManager as? AuthenticationMock)?.signUpWithFirebaseError = .registrationError
        
        authManager.signUpWithFirebase(email: "test@example.com", password: "password123") { result in
            switch result {
            case .success():
                XCTFail("Expected failure, but got success instead")
            case .failure(let error as ErrorCase):
                XCTAssertEqual(error, .registrationError)
                XCTAssertEqual(error.message, "Registration failed. Check your information")
                expectation.fulfill()
            default:
                XCTFail("Unexpected error type")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

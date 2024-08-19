//
//  RealmDataManager.swift
//  ExpensesBook
//
//  Created by Vinicius Gibran on 19/08/2024.
//

import Foundation
import RealmSwift

enum RealmError: Error {
    case initializationFailed
    case operationFailed(error: Error)
    case objectNotFound(message: String)
}

class RealmDataManager {
    
    // MARK: - Load Items
    
    func loadAsync<T: Object>(_ type: T.Type, byPrimaryKey key: Any) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let realm = try Realm()
                    guard let object = realm.object(ofType: T.self, forPrimaryKey: key) else {
                        throw RealmError.objectNotFound(message: "Object of type \(T.self) with key \(key) was not found.")
                    }
                    DispatchQueue.main.async {
                        continuation.resume(returning: object)
                    }
                } catch {
                    print("Error fetching object: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        continuation.resume(throwing: RealmError.operationFailed(error: error))
                    }
                }
            }
        }
    }
    
    func loadAllAsync<T: Object>(_ type: T.Type) async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let realm = try Realm()
                    let results = realm.objects(T.self)
                    let array = Array(results)
                    DispatchQueue.main.async {
                        continuation.resume(returning: array)
                    }
                } catch {
                    print("Error fetching objects: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        continuation.resume(throwing: RealmError.operationFailed(error: error))
                    }
                }
            }
        }
    }
    
    // MARK: - Save Items
    
    func saveAsync<T: Object>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(object)
                    }
                    DispatchQueue.main.async {
                        continuation.resume()
                    }
                } catch {
                    print("Error saving object: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        continuation.resume(throwing: RealmError.operationFailed(error: error))
                    }
                }
            }
        }
    }
    
    func saveAllAsync<T: Object>(_ objects: [T]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(objects)
                    }
                    DispatchQueue.main.async {
                        continuation.resume()
                    }
                } catch {
                    print("Error saving objects: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        continuation.resume(throwing: RealmError.operationFailed(error: error))
                    }
                }
            }
        }
    }
    
    // MARK: - Delte Item
    
    func deleteAsync<T: Object>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.delete(object)
                    }
                    DispatchQueue.main.async {
                        continuation.resume()
                    }
                } catch {
                    print("Error deleting object: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        continuation.resume(throwing: RealmError.operationFailed(error: error))
                    }
                }
            }
        }
    }
}

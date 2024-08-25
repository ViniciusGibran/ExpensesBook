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

    // Dedicated serial queue for all Realm operations
    internal let realmQueue = DispatchQueue(label: "com.expensesbook.realmQueue", qos: .userInitiated)
    
    // MARK: - Load Items

    func loadAsync<T: Object>(_ type: T.Type, byPrimaryKey key: Any) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                var frozenObject: T?
                defer { frozenObject = nil }
                do {
                    let realm = try Realm()
                    guard let object = realm.object(ofType: T.self, forPrimaryKey: key) else {
                        throw RealmError.objectNotFound(message: "Object of type \(T.self) with key \(key) was not found.")
                    }
                    
                    frozenObject = object.freeze()
                    continuation.resume(returning: frozenObject)
                } catch {
                    print("Error fetching object: \(error.localizedDescription)")
                    continuation.resume(throwing: RealmError.operationFailed(error: error))
                }
            }
        }
    }
    
    func loadAllAsync<T: Object>(_ type: T.Type) async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                var frozenResults: [T] = []
                defer { frozenResults.removeAll() }
                do {
                    let realm = try Realm()
                    let results = realm.objects(T.self)
                    frozenResults = results.map { $0.freeze() }
                    continuation.resume(returning: frozenResults)
                } catch {
                    print("Error fetching objects: \(error.localizedDescription)")
                    continuation.resume(throwing: RealmError.operationFailed(error: error))
                }
            }
        }
    }
    
    // MARK: - Save Items

    func saveAsync<T: Object>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(object, update: .modified) // Use .modified for updates as well
                    }
                    continuation.resume()
                } catch {
                    print("Error saving object: \(error.localizedDescription)")
                    continuation.resume(throwing: RealmError.operationFailed(error: error))
                }
            }
        }
    }
    
    func saveAllAsync<T: Object>(_ objects: [T]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(objects, update: .modified) // Same as above
                    }
                    continuation.resume()
                } catch {
                    print("Error saving objects: \(error.localizedDescription)")
                    continuation.resume(throwing: RealmError.operationFailed(error: error))
                }
            }
        }
    }
    
    // MARK: - Delete Items

    func deleteAsync<T: Object>(_ object: T) async throws {
        try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try Realm()
                    guard let id = object.value(forKey: "id"),
                          let existingObject = realm.object(ofType: T.self, forPrimaryKey:id)
                    else { throw RealmError.objectNotFound(message: "Object of type \(T.self) not found.") }
                    try realm.write {
                        realm.delete(existingObject)
                    }
                    continuation.resume()
                } catch {
                    print("Error deleting object: \(error.localizedDescription)")
                    continuation.resume(throwing: RealmError.operationFailed(error: error))
                }
            }
        }
    }
    
    // MARK: - Check Item Existence

    func objectExists<T: Object>(_ type: T.Type, byPrimaryKey key: ObjectId) async -> Bool {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try Realm()
                    let objectExists = realm.object(ofType: T.self, forPrimaryKey: key) != nil
                    continuation.resume(returning: objectExists)
                } catch {
                    print("Error checking existence: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
}

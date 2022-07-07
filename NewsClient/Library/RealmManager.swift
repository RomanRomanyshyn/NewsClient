//
//  RealmManager.swift
//  NewsClient
//
//  Created by Roman Romanyshyn on 30.06.2022.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private init() {}

    private func getRealm() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            print(error)
            print(error.localizedDescription)
            return nil
        }
    }

    func objects<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) -> Results<T>? {
        guard let realm = getRealm() else { return nil }

        realm.refresh()

        return predicate == nil ? realm.objects(type) : realm.objects(type).filter(predicate!)
    }

    func object<T: Object>(_ type: T.Type, key: Any) -> T? {
        guard let realm = getRealm() else { return nil }

        realm.refresh()

        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func add<T: Object>(_ data: T, completion: (() -> Void)? = nil) {
        guard let realm = getRealm() else { return }

        realm.refresh()

        if realm.isInWriteTransaction {
            let copy = realm.create(T.self, value: data, update: .all)
            realm.add(copy)
        } else {
            try? realm.write {
                let copy = realm.create(T.self, value: data, update: .modified)
                realm.add(copy)
                completion?()
            }
        }
    }

    func runTransaction(action: () -> Void) {
        guard let realm = getRealm() else { return }

        realm.refresh()

        try? realm.write {
            action()
        }
    }

    func delete<T: Object>(_ data: T, completion: (() -> Void)? = nil) {
        guard let realm = getRealm() else { return }

        guard let keyValue = getPrimaryValue(for: data),
              let unlikedObject = object(T.self, key: keyValue) else { return }

        realm.refresh()
        try? realm.write {
            realm.delete(unlikedObject)
            completion?()
        }
    }

    func clearAllData() {
        guard let realm = getRealm() else { return }

        realm.refresh()
        try? realm.write {
            realm.deleteAll()
        }
    }
}

extension RealmManager {
    func getPrimaryValue<T: Object>(for object: T) -> Any? {
        guard let keyName = T.primaryKey(),
              let keyValue = object.value(forKey: keyName) else { return nil }
        return keyValue
    }
}

import Testing
import Foundation
import cpp_intepop
import rocksdb
/*@testable*/ import swift_rocksdb

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    var options = rocksdb.Options()
    options.create_if_missing = true
    options.create_missing_column_families = true
    
    var existingColumnFamilies = swiftrocks.ColumnFamiliesVector([
        rocksdb.kDefaultColumnFamilyName
    ])
    
    let tmpDBPath = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
    defer {
        try? FileManager.default.removeItem(at: tmpDBPath)
    }
    let status = swiftrocks.ListColumnFamilies(
        rocksdb.DBOptions(), std.string(tmpDBPath.path), &existingColumnFamilies)
    #expect(status.ok()
            || status == .PathNotFound() && options.create_if_missing)
    
    let columnFamilyDescriptors = swiftrocks.ColumnFamilyDescriptorVector(
        Set(existingColumnFamilies + ["mycf1", "mycf2"]).map({
            var cfo = rocksdb.ColumnFamilyOptions()
            cfo.disable_auto_compactions = true  // there seems to be a bug, see https://github.com/facebook/rocksdb/issues/12888
            return rocksdb.ColumnFamilyDescriptor(
                $0, cfo)
        }))
    var handles = swiftrocks.ColumnFamilyHandlePointerVector()
    
    let dbOpenResult = swiftrocks.Open(
        options, rocksdb.TransactionDBOptions(), columnFamilyDescriptors,
        &handles, std.string(tmpDBPath.path))
    
    let columnID = swiftrocks.GetName(handles.first!)
    print(columnID.pointee)
    
    #expect(dbOpenResult.status.ok())
    let db = dbOpenResult.db
    defer {
        handles.forEach { swiftrocks.DestroyColumnFamilyHandle(db, $0) }
        #expect(swiftrocks.Close(db).ok())
    }
    
    #expect(db.EnableAutoCompaction(handles).ok())
    
    let transaction = db.BeginTransaction(
        rocksdb.WriteOptions(), rocksdb.TransactionOptions())
    
    let one = "1"
    one.withCString { p in
        #expect(transaction.Put(rocksdb.Slice(p), rocksdb.Slice(p)).ok())
    }
    let two = "22"
    two.withCString { p in
        #expect(transaction.Put(rocksdb.Slice(p), rocksdb.Slice(p)).ok())
    }
    let three = "333"
    three.withCString { p in
        #expect(transaction.Put(
            rocksdb.Slice(p, three.count), rocksdb.Slice(p, three.count)).ok())
    }
    
    let iterator = transaction.GetIterator(rocksdb.ReadOptions())
    
    iterator.dropFirst(1).filter({ $0.0.ToString() != "22" }).forEach {
        element in
        let key = String(decoding: element.0.asArray(), as: UTF8.self)
        print(key, element.1.ToString())
    }
    
    for element in iterator {
        print(element.key, element.value.ToString())
    }
    
    print(iterator.contains { $0.0.ToString() == "1" })
    
    two.withCString({
        var value = std.string()
        #expect(transaction.Get(
            rocksdb.ReadOptions(), rocksdb.Slice($0), &value).ok())
        print(value)
    })
    
    #expect(transaction.Commit().ok())
}

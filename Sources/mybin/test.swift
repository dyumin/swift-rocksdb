import cpp_intepop
import rocksdb
import swift_rocksdb

@main
struct App {
    static func main() throws {
        var options = rocksdb.Options()
        options.create_if_missing = true
        options.create_missing_column_families = true

        var existingColumnFamilies = swiftrocks.ColumnFamiliesVector([
            rocksdb.kDefaultColumnFamilyName
        ])
        var status = swiftrocks.ListColumnFamilies(
            rocksdb.DBOptions(), "/tmp/rocks", &existingColumnFamilies)
        guard
            status.ok()
                || status == .PathNotFound() && options.create_if_missing
        else {
            throw status
        }

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
            &handles, "/tmp/rocks")

        guard dbOpenResult.status.ok() else {
            throw dbOpenResult.status
        }
        let db = dbOpenResult.db
        defer {
            handles.forEach { swiftrocks.DestroyColumnFamilyHandle(db, $0) }
        }

        status = db.EnableAutoCompaction(handles)
        guard status.ok() else {
            throw dbOpenResult.status
        }

        //        status = db.Open()
        //        if !status.ok() {
        //            print(status)
        //        }

        var transaction = db.BeginTransaction(
            rocksdb.WriteOptions(), rocksdb.TransactionOptions())

        let one = "1"
        one.withCString { p in
            status = transaction.Put(rocksdb.Slice(p), rocksdb.Slice(p))
        }
        let two = "22"
        two.withCString { p in
            status = transaction.Put(rocksdb.Slice(p), rocksdb.Slice(p))
        }
        let three = "333"
        three.withCString { p in
            status = transaction.Put(
                rocksdb.Slice(p, three.count), rocksdb.Slice(p, three.count))
        }

        let iterator = transaction.GetIterator(rocksdb.ReadOptions())

        iterator.dropFirst(1).filter({ $0.0.ToString() != "22" }).forEach {
            element in
            print(element.0.ToString(), element.1.ToString())
        }

        for element in iterator {
            print(element.key.ToString(), element.value.ToString())
        }

        print(iterator.contains { $0.0.ToString() == "1" })

        try! two.withCString({
            var value = std.string()
            status = transaction.Get(
                rocksdb.ReadOptions(), rocksdb.Slice($0), &value)
            guard status.ok()
            else {
                throw status
            }
            print(value)
        })

        status = transaction.Commit()
        guard status.ok() else { throw status }
    }
}

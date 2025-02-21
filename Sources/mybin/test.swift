import cpp_intepop
import rocksdb
import swift_rocksdb

@main
struct App {
    static func main() throws {
        var existingColumnFamilies = swiftrocks.ColumnFamiliesVector()
        var status = swiftrocks.ListColumnFamilies(
            rocksdb.DBOptions(), "/tmp/rocks", &existingColumnFamilies)
        guard status.ok() else {
            throw status
        }

        let columnFamilyDescriptors = swiftrocks.ColumnFamilyDescriptorVector(
            Set(existingColumnFamilies + ["mycf1", "mycf2"]).map({
                rocksdb.ColumnFamilyDescriptor(
                    $0, rocksdb.ColumnFamilyOptions())
            }))
        var handles = swiftrocks.ColumnFamilyHandlePointerVector()

        var options = rocksdb.Options()
        options.create_if_missing = true
        options.create_missing_column_families = true

        var db = swiftrocks.Open(
            options, rocksdb.TransactionDBOptions(), columnFamilyDescriptors,
            &handles, "/tmp/rocks")
        guard db.__convertToBool() else {
            print("failed to open db")
            return
        }
        defer {
            handles.forEach { swiftrocks.DestroyColumnFamilyHandle(db, $0) }
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
            status = transaction.Put(rocksdb.Slice(p), rocksdb.Slice(p))
        }

        let iterator = transaction.GetIterator(rocksdb.ReadOptions())

        iterator.dropFirst(1).filter({ $0.0.ToString() != "22" }).forEach {
            element in
            print(element.0.ToString(), element.1.ToString())
        }

        for element in iterator {
            print(element.0.ToString(), element.1.ToString())
        }

        print(iterator.contains { $0.0.ToString() == "1" })
    }
}

import cpp_intepop
import rocksdb
import swift_rocksdb

@main
struct App {
    static func main() throws {
        var columnFamilies = swiftrocks.ColumnFamiliesVector()
        var status = swiftrocks.ListColumnFamilies(
            rocksdb.DBOptions(), "/tmp/rocks", &columnFamilies)
        guard status.ok() else {
            throw status
        }

        let columnFamilyDescriptors = swiftrocks.ColumnFamilyDescriptorVector(
            (columnFamilies + ["mycf1", "mycf2"]).map({
                rocksdb.ColumnFamilyDescriptor(
                    $0, rocksdb.ColumnFamilyOptions())
            }))
        var handles = swiftrocks.ColumnFamilyHandlePointerVector()

        var options = rocksdb.Options()
        options.create_if_missing = true
        options.create_missing_column_families = true

        var db = swiftrocks.TransactionDB()
        status = db.Open(
            options, rocksdb.TransactionDBOptions(), columnFamilyDescriptors,
            &handles, "/tmp/rocks")
        if !status.ok() {
            print(status)
        }
    }
}

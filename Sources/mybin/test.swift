import rocksdb
import cpp_intepop

import swift_rocksdb

@main
struct App {
    static func main() {

        // let tpc = rocksdb.TablePropertiesCollection()
        var options = rocksdb.Options()
        options.create_if_missing = true
        
        var db = swiftrocks.TransactionDB()
        let status = db.Open(options, rocksdb.TransactionDBOptions(), "/tmp/rocks")
        if status == .OK() {
            
        }

    }
}

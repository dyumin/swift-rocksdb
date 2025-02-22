import cpp_intepop
import rocksdb

extension rocksdb.Status: Error, CustomStringConvertible, @unchecked Sendable {
    public var description: String {
        "\(ToString())"
    }
}

public class Iterator: IteratorProtocol {

    let handle: swiftrocks.Iterator
    var first = true

    init(handle: swiftrocks.Iterator) {
        self.handle = handle
        swiftrocks.SeekToFirst(self.handle)
    }

    public func next() -> (rocksdb.Slice, rocksdb.Slice)? {
        guard swiftrocks.Valid(handle) else {
            return nil
        }
        if first {
            first = false
        } else {
            swiftrocks.Next(handle)
            guard swiftrocks.Valid(handle) else {
                return nil
            }
        }

        return (swiftrocks.key(handle), swiftrocks.value(handle))
    }

    public typealias Element = (rocksdb.Slice, rocksdb.Slice)
}

extension swiftrocks.Iterator: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(handle: self)
    }
}

extension swiftrocks.TransactionDB {
    public func BeginTransaction(
        _ writeOptions: rocksdb.WriteOptions,
        _ transactionOptions: rocksdb.TransactionOptions
    ) -> swiftrocks.Transaction {
        return swiftrocks.BeginTransaction(
            self, writeOptions, transactionOptions)
    }
}

extension swiftrocks.Transaction {
    public func GetIterator(
        _ options: rocksdb.ReadOptions
    ) -> swiftrocks.Iterator {
        return swiftrocks.GetIterator(self, options)
    }

    public func Put(_ key: rocksdb.Slice, _ value: rocksdb.Slice)
        -> rocksdb.Status
    {
        return swiftrocks.Put(self, key, value)
    }
}

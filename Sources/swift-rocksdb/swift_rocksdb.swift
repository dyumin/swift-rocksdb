import CxxStdlib
import cpp_intepop
import rocksdb

extension rocksdb.Status: Error, CustomStringConvertible, @unchecked Sendable {
    @inlinable
    public var description: String {
        "\(ToString())"
    }
}

public class Iterator: IteratorProtocol {
    @usableFromInline
    let handle: swiftrocks.Iterator
    @usableFromInline
    var first = true

    @inlinable
    init(handle: swiftrocks.Iterator) {
        self.handle = handle
        swiftrocks.SeekToFirst(self.handle)
    }

    @inlinable
    public func next() -> (rocksdb.Slice, rocksdb.Slice)? {
        if first {
            guard swiftrocks.Valid(handle) else {
                return nil
            }
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
    @inlinable
    public func makeIterator() -> Iterator {
        return Iterator(handle: self)
    }
}

extension swiftrocks.TransactionDB {
    @inlinable
    public func BeginTransaction(
        _ writeOptions: rocksdb.WriteOptions,
        _ transactionOptions: rocksdb.TransactionOptions
    ) -> swiftrocks.Transaction {
        return swiftrocks.BeginTransaction(
            self, writeOptions, transactionOptions)
    }
}

extension swiftrocks.Transaction {
    @inlinable
    public func GetIterator(
        _ options: rocksdb.ReadOptions
    ) -> swiftrocks.Iterator {
        return swiftrocks.GetIterator(self, options)
    }

    @inlinable
    public func Put(_ key: rocksdb.Slice, _ value: rocksdb.Slice)
        -> rocksdb.Status
    {
        return swiftrocks.Put(self, key, value)
    }
}

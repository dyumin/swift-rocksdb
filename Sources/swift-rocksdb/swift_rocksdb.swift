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
    @usableFromInline
    let rocksDBIterator: OpaquePointer!  // to avoid double pointer hopping

    @inlinable
    init(handle: swiftrocks.Iterator) {
        self.handle = handle
        rocksDBIterator = swiftrocks.GetIterator(handle)
        swiftrocks.SeekToFirst(rocksDBIterator)
    }

    @inlinable
    public func next() -> (key: rocksdb.Slice, value: rocksdb.Slice)? {
        if first {
            guard swiftrocks.Valid(rocksDBIterator) else {
                return nil
            }
            first = false
        } else {
            swiftrocks.Next(rocksDBIterator)
            guard swiftrocks.Valid(rocksDBIterator) else {
                return nil
            }
        }

        return (
            swiftrocks.key(rocksDBIterator), swiftrocks.value(rocksDBIterator)
        )
    }

    public typealias Element = (key: rocksdb.Slice, value: rocksdb.Slice)
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

#pragma once

#include <rocksdb/db.h>
#include <rocksdb/utilities/transaction_db.h>
#include <tuple>

namespace swiftrocks {

using namespace rocksdb;

using ColumnFamilyDescriptorVector = std::vector<ColumnFamilyDescriptor>;
using ColumnFamilyHandlePointerVector = std::vector<ColumnFamilyHandle *>;
using ColumnFamilyHandleUniquePtr = std::unique_ptr<ColumnFamilyHandle>;

using ColumnFamiliesVector = std::vector<std::string>;
inline Status ListColumnFamilies(const DBOptions &db_options,
                                 const std::string &name,
                                 ColumnFamiliesVector *column_families) {
    return rocksdb::DB::ListColumnFamilies(db_options, name, column_families);
}

using Transaction = std::unique_ptr<Transaction>;
using Iterator = std::shared_ptr<Iterator>;

using TransactionDB = std::unique_ptr<TransactionDB>;

inline void
DestroyColumnFamilyHandle(const TransactionDB &transactionDB,
                          ColumnFamilyHandle *columnFamilyHandle) noexcept {
    transactionDB->DestroyColumnFamilyHandle(columnFamilyHandle);
}

inline TransactionDB Open(const Options &options,
                          const TransactionDBOptions &txn_db_options,
                          const ColumnFamilyDescriptorVector &column_families,
                          ColumnFamilyHandlePointerVector *handles,
                          const std::string &dbname) noexcept {
    // it crashes for some reason
    //    m_columnDescriptors.reserve(
    //        column_families.size()); // after this assighment will not throw

    rocksdb::TransactionDB *dbptr = nullptr;
    auto status = rocksdb::TransactionDB::Open(
        options, txn_db_options, dbname, column_families, handles, &dbptr);

    return TransactionDB(dbptr);
}

inline Transaction
BeginTransaction(const TransactionDB &transactionDB,
                 const WriteOptions &write_options,
                 const TransactionOptions &txn_options) noexcept {
    return Transaction(
        transactionDB->BeginTransaction(write_options, txn_options));
}

inline Iterator GetIterator(const Transaction &transaction,
                            const ReadOptions &options) noexcept {
    return Iterator(transaction->GetIterator(options));
}

inline Status Put(const Transaction &transaction, const Slice &key,
                  const Slice &value) noexcept {
    return transaction->Put(key, value);
}

inline bool Valid(const Iterator &iterator) noexcept {
    return iterator->Valid();
}
inline void SeekToFirst(const Iterator &iterator) noexcept {
    iterator->SeekToFirst();
}
inline Slice key(const Iterator &iterator) noexcept { return iterator->key(); }
inline Slice value(const Iterator &iterator) noexcept {
    return iterator->value();
}
inline void Next(const Iterator &iterator) noexcept { return iterator->Next(); }

inline Status status(const Iterator &iterator) noexcept {
    return iterator->status();
}

} // namespace swiftrocks

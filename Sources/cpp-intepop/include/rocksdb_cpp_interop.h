#pragma once

#include <rocksdb/db.h>
#include <rocksdb/utilities/transaction_db.h>

namespace swiftrocks {

using namespace rocksdb;

using ColumnFamilyDescriptorVector = std::vector<ColumnFamilyDescriptor>;
using ColumnFamilyHandlePointerVector = std::vector<ColumnFamilyHandle *>;

using ColumnFamiliesVector = std::vector<std::string>;
Status ListColumnFamilies(const DBOptions &db_options, const std::string &name,
                          ColumnFamiliesVector *column_families);

class TransactionDB {
public:
  TransactionDB() noexcept = default;
  ~TransactionDB() noexcept;

  Status Open(const Options &options,
              const TransactionDBOptions &txn_db_options,
              const ColumnFamilyDescriptorVector &column_families,
              ColumnFamilyHandlePointerVector *handles,
              const std::string &dbname) noexcept;

  Iterator *NewIterator(const ReadOptions &options) noexcept;

  std::shared_ptr<rocksdb::TransactionDB> m_db;
};

} // namespace swiftrocks

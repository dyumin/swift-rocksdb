#include "rocksdb_cpp_interop.h"

namespace swiftrocks {

Status TransactionDB::Open(const Options &options,
                           const TransactionDBOptions &txn_db_options,
                           const std::string &dbname) noexcept {
  rocksdb::TransactionDB *dbptr = nullptr;

  auto status =
      rocksdb::TransactionDB::Open(options, txn_db_options, dbname, &dbptr);

  std::shared_ptr<rocksdb::TransactionDB> db(dbptr);
  if (status == rocksdb::Status::OK()) {
    m_db.swap(db);
  }

  return status;
}

Iterator *TransactionDB::NewIterator(const ReadOptions &options) {

  auto tx = m_db->BeginTransaction({}, {});
  auto txiterator = tx->GetIterator({});

  return m_db->NewIterator(options);
}

TransactionDB::~TransactionDB() {}

} // namespace swiftrocks
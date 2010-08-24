module E20
  module Ops
    autoload :Revision, "e20/ops/revision"
    autoload :Hostname, "e20/ops/hostname"

    module Middleware
      autoload :HostnameMiddleware, "e20/ops/middleware/hostname_middleware"
      autoload :RevisionMiddleware, "e20/ops/middleware/revision_middleware"
      autoload :TransactionIdMiddleware, "e20/ops/middleware/transaction_id_middleware"
    end
  end
end

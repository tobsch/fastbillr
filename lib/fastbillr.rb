require "fastbillr/version"

module Fastbillr
  require "excon"
  require "json"
  require "hashie"

  autoload :Model, "fastbillr/model"
  autoload :Configuration, "fastbillr/configuration"
  autoload :Request, "fastbillr/request"
  autoload :Result, "fastbillr/result"
  autoload :Error, "fastbillr/error"
  autoload :Customer, "fastbillr/customer"
  autoload :Invoice, "fastbillr/invoice"
  autoload :Expense, "fastbillr/expense"
  autoload :Template, "fastbillr/template"
end

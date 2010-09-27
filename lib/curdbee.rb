require 'hashie'
require 'httparty'
require 'json'

module CurdBee
  VERSION = '0.0.1'.freeze

  autoload :Base,         'curdbee/base'
  autoload :Config,       'curdbee/config'
  autoload :Client,       'curdbee/client'
  autoload :Error,        'curdbee/error'
  autoload :Estimate,     'curdbee/estimate'
  autoload :Invoice,      'curdbee/invoice'
  autoload :Invoiceable,  'curdbee/invoiceable'
  autoload :Item,         'curdbee/item'
  autoload :Parser,       'curdbee/parser'
  autoload :Payment,      'curdbee/payment'
  autoload :RecurringProfile, 'curdbee/recurring_profile'

end

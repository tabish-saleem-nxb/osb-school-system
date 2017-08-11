class ClientType < ActiveRecord::Base
  has_one :penalty_rule
  has_one :term_rule
end

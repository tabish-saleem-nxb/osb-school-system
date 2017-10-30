class ClientType < ActiveRecord::Base
  has_one :penalty_rule
end

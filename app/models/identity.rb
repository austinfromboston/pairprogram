class Identity < ActiveRecord::Base
  belongs_to :person
  serialize :info
end

# frozen_string_literal: true

# ApplicationRecord serves as the superclass for all models in the app.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end

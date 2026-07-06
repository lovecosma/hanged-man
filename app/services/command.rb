# frozen_string_literal: true

module Command
  extend ActiveSupport::Concern

  included do
    extend Dry::Initializer
  end

  class_methods do
    def run(**args)
      new(**args).call
    end
  end
end

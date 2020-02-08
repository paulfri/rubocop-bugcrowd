# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module Bugcrowd
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class DangerousTransaction < Cop
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Use `#good_method` instead of `#bad_method`.'

        def_node_matcher :consts_that_transaction_may_be_called_on, <<-PATTERN
          {(send (const nil? _) :transaction ...) (send (const (const nil? :ActiveRecord) :Base) :transaction ...)}
        PATTERN

        def_node_matcher :transaction_called_in_a_safe_way?, <<~PATTERN
          (send (const (const nil? :ActiveRecord) :Base) :transaction
            (hash
              (pair
                (sym :joinable)
                (false))
              (pair
                (sym :requires_new)
                (true))
            )
          )
        PATTERN

        def on_send(node)
          if consts_that_transaction_may_be_called_on(node) &&
             !transaction_called_in_a_safe_way?(node)
            add_offense(node)
          end
        end
      end
    end
  end
end

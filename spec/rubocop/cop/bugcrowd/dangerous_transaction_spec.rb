# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Bugcrowd::DangerousTransaction do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  # TODO: Write test code
  #
  # For example
  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      Model.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      Model.transaction { |d| d.doing_a_thing }
      ^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      Model.transaction do |d|
      ^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      Model.transaction(joinable: true, requires_new: true) do |d|
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
        d.doing_a_thing
      end
    RUBY
  end

  it 'registers an offense when using `#bad_method`' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
    RUBY
  end

  it 'registers an offense when not using AR base' do
    expect_offense(<<~RUBY)
      ActiveRecord::Base.transaction { doing_a_thing }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#good_method` instead of `#bad_method`.
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      ActiveRecord::Base.transaction(joinable: false, requires_new: true) do |d|
        d.doing_a_thing
      end
    RUBY
  end

  it 'does not register an offense when using `#good_method`' do
    expect_no_offenses(<<~RUBY)
      ActiveRecord::Base.transaction(joinable: false, requires_new: true) { doing_a_thing }
    RUBY
  end
end

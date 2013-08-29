require 'spec_helper'

describe 'Listing stanzas' do
  before do
    visit '/'
  end

  it 'Show all stanzas' do
    page.should have_text('hello')
  end
end

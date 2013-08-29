require 'spec_helper'

describe 'Listing stanzas' do
  before do
    visit '/'
  end

  it 'Show all stanzas' do
    page.should have_text('foo')
    page.should have_text('bar')
  end

  it 'Show link to help page' do
    page.should have_link('help', href: '/foo/help')
    page.should have_link('help', href: '/bar/help')
  end
end

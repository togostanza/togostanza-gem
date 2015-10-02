require 'spec_helper'

describe 'Help' do
  it 'should display FooStanza help' do
    visit '/foo/help'
    page.should have_css('h1', text: 'Foo')
  end

  it 'should display BarStanza help' do
    visit '/bar/help'
    page.should have_text('Work in progress')
  end
end

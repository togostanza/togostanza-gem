require 'spec_helper'

describe 'Rendering' do
  it 'should render FooStanza correctly' do
    visit '/foo'
    page.should have_content('hello from foo')
  end

  it 'should render BarStanza correctly' do
    visit '/bar'
    page.should have_content('hello from bar')
  end
end

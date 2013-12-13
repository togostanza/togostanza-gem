require 'spec_helper'

describe 'API' do
  it 'should return properties as JSON' do
    visit '/foo.json?name=nsgc'

    json = JSON.parse(page.body)
    json.should include('name' => 'nsgc')
  end
end

require 'spec_helper'

describe 'Metadata' do
  it 'should return metadata as JSON' do
    visit '/foo/metadata.json'

    json = JSON.parse(page.body)
    json.should include('stanza:label' => 'Foo Stanza')
  end
end

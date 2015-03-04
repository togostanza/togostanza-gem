require 'spec_helper'

describe 'Metadata' do
  describe '/metadata.json' do
    before do
      # 実行順により base_spec で作られた Classオブジェクトが返って来て意図通りのテストにならないため
      allow(TogoStanza::Stanza).to receive(:all).and_return([BarStanza, FooStanza])

      visit '/metadata.json'
    end

    it 'should return metadata as JSON' do
      json = JSON.parse(page.body)

      json.class.should eq(Array)
      json.first.should include('stanza:label' => 'Foo Stanza')
    end
  end

  describe '/:id/metadata.json' do
    before do
      visit '/foo/metadata.json'
    end

    it 'should return metadata as JSON' do
      json = JSON.parse(page.body)

      json.should include('stanza:label' => 'Foo Stanza')
    end
  end
end

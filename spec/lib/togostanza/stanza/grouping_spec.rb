require 'spec_helper'

describe TogoStanza::Stanza::Grouping do
  specify do
    data = [
      {cpd1: 'cpd1-1', cpd2: 'cpd2-1', ec: 'ec-1', gene: 'gene-1'},
      {cpd1: 'cpd1-1', cpd2: 'cpd2-1', ec: 'ec-1', gene: 'gene-2'},
      {cpd1: 'cpd1-1', cpd2: 'cpd2-1', ec: 'ec-2', gene: 'gene-3'},
      {cpd1: 'cpd1-2', cpd2: 'cpd2-2', ec: 'ec-3', gene: 'gene-4'}
    ]

    TogoStanza::Stanza::Grouping.grouping(data, {[:cpd1, :cpd2] => :cpd}, :ec, :gene).should == [
      {
        :cpd => ["cpd1-1", "cpd2-1"],
        :ec => [
          {:ec => "ec-1", :gene => ["gene-1", "gene-2"]},
          {:ec => "ec-2", :gene => ["gene-3"]}
        ]
      },
      {
        :cpd => ["cpd1-2", "cpd2-2"],
        :ec => [
          {:ec => "ec-3", :gene => ["gene-4"]}
        ]
      }
    ]
  end
end

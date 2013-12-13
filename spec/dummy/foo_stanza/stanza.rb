class FooStanza < TogoStanza::Stanza::Base
  property :name do |name|
    name || 'foo'
  end

  resource :foo_resource do
    {hello: 'world'}
  end
end

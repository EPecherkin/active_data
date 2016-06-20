class ActiveData::Config::PersistenceAdapters < Hash
  def default(*args)
    @default ||= ActiveData::Model::Associations::PersistenceAdapters::ActiveRecord
  end

  def [](klass)
    super(normalize(klass))
  end

  def []=(klass, adapter)
    super(normalize(klass), adapter.is_a?(Class) ? adapter : normalize(adapter).constantize)
  end

  def normalize(key)
    case key
    when String
      key.camelize
    when Symbol
      key.to_s.camelize
    when Class
      key.name
    end
  end
end

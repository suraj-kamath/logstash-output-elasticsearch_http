class MockLogger
  def initialize
    @content = []
  end

  def info(*value)
  end
  alias_method :debug, :info

  def warn(*value)
    @content << value.join(' ')
  end

  def content
    @content.join("\n")
  end
end

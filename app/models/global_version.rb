class GlobalVersion
  attr_accessor :name, :versions, :status

  def initialize(name)
    @name = name
    @status = 'closed'
    @versions = []
  end

  def addList(version)
    @versions << version
    if (!version.closed? && !version.completed?)
        @status = 'open'
    end
  end

end

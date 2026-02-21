# A common base class for services
class ApplicationService
  def self.call(...)
    new(...).call
  end
end

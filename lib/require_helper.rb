module DatatablesRails
  def self.require_dir(*directories)
    directories.each do |dir|
      Dir[File.join(File.dirname(__FILE__), dir, '*.rb')].each {|file| require file }
    end
  end
end
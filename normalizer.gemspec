Gem::Specification.new do |s|
	s.name						= "normalizer"
	s.summary					= "Parses XML files, wrapping and normalizing exhibits inside ref nodes inside note nodes"
	s.description				= File.read(File.join(File.dirname(__FILE__), 'README'))
	s.requirements				= [ 'nokogiri' ]
	s.version					= "1.0.0"
	s.author					= "Michael Weigle"
	s.email						= "michael.weigle@gmail.com"
	s.platform					= Gem::Platform::RUBY
	s.required_ruby_version		= '>=1.9'
	s.files						= Dir['**/**']
	s.executables				= [ 'normalizer' ]
	s.test_files				= Dir["test/test*.rb"]
	s.has_rdoc					= false
end

require 'nokogiri'

module Normalizer
	class Runner

		def initialize(argv)
			if ARGV[0] == '-f'
				runthis(ARGV[1], :file)
			elsif ARGV[0] == '-d'
				runthis(Dir.entries(ARGV[1]), :dir)
			else
				puts 'Usage: normalizer [-f filename | -d directory]'
			end
		end

		def runthis(files, type)
			if files.nil?
				raise "no files"
			end
			
			if type == :file
				parse(files)
			elsif type == :dir
				files.each do |f|
					next if f == '.' or f == '..'
					parse(ARGV[1] + f)
				end
			end
		end

		def parse(file)
			puts 'parsing ' + file
			doc = Nokogiri::XML(File.new(file))

			notes = doc.xpath('//tei:note', {'tei' => "http://www.tei-c.org/ns/1.0"})
			puts 'writing ' + notes.length.to_s + ' nodes'
			
			notes.each do |n|
				offset = 0
				matchdata = Array.new
				n.inner_html.scan(/ex+|\d+-?[a-z]?/i) {|i| matchdata.push $~}
				matchtext = n.inner_html.scan(/(?<=^|\s|\A)ex{1}|\d+-?[a-z]?/i)

				unless matchdata.length <= 1
					matchdata.each_index do |i|
						if matchtext[i] != nil && matchtext[i+1] != nil && matchtext[i].start_with?('e', 'E')
							start = offset + matchdata[i+1].offset(0)[0]
							length = matchtext[i+1].length
							number = n.inner_html[start, length]

							numNum = number[/[0-9]+/]
							if numNum.nil?
								break
							else
								numNum = numNum.rjust(4, '0')
							end

							numText = number[/[a-z]/i]
							numText = numText.nil? ? '' : numText.downcase

							formednum = numNum + numText

							newstring = "<ref target=\"exhibit-" + formednum + ".xml\">"
							n.inner_html = n.inner_html.insert(offset + matchdata[i].offset(0)[0], newstring)
							offset += newstring.length

							newstring = "</ref>"
							n.inner_html = n.inner_html.insert(offset + matchdata[i+1].offset(0)[1], newstring)
							offset += newstring.length
						end
					end
				end
			end

			IO.write(file, doc.to_xml)
			puts 'writing ' + file
			puts
		end
	end
end

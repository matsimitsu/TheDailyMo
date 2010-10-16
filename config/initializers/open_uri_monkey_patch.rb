# http://www.megasolutions.net/ruby/Problem-with-open-uri-78351.aspx

require 'open-uri'

module OpenURI
	def OpenURI.redirectable?(uri1, uri2) # :nodoc: 
	  # This test is intended to forbid a redirection from http://... to 
	  # file:///etc/passwd. 
	  # However this is ad hoc.  It should be extensible/configurable. 
	  uri1.scheme.downcase == uri2.scheme.downcase || 
    (/\A(?:http|ftp|https)\z/i =~ uri1.scheme && /\A(?:http|ftp|https)\z/i =~ uri2.scheme) 
	end
end

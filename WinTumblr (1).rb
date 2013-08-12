require "mscorlib"
require "System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.Collections.Generic, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.Text, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.Net, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.IO, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
require "System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

module WinTumblr
	class TumblrEventArgs < EventArgs
		def initialize(message)
			self.@message = message
		end
	end
	class tumblr
		def initialize()
			# Lets create classes for each of the message types for
			# future features that may include offline storage of messages.
			# This will enable you to enter a bunch of posts and upload them 
			# when you are connected to the internet (if you implement that 
			# feature of course).
			# This class will convert a file into a URL-encoded string
			# and store the string in sData. I thought of doing it in the  
			# btnPost_Click event, however I felt it would be a better 
			# design decision to have it as part of the Photo object.
			# Check whether the file exists and stream it-->url-encode it
			# Let the user know what went wrong.
			@generator = "WinTumblr v1.3 http://www.feedfeast.com/wintumblr"
		end

		class Account
			def initialize()
				@sEmail = ""
				@sPassword = ""
			end

			def Email
				return @sEmail
			end

			def Email=(value)
				@sEmail = value
			end

			def Password
				return @sPassword
			end

			def Password=(value)
				@sPassword = value
			end
		end
		class Text < Account
			def initialize()
				@sTitle = ""
				@sBody = ""
			end

			def Title
				return @sTitle
			end

			def Title=(value)
				@sTitle = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end

			def Body
				return @sBody
			end

			def Body=(value)
				@sBody = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end
		class Photo < Account
			def initialize()
				@sSource = ""
				@sData = ""
				@sCaption = ""
			end

			def Source
				return @sSource
			end

			def Source=(value)
				@sSource = value
			end

			def Data
				return @sData
			end

			def Data=(value)
				if value.Length > 0 then
					if System.IO.File.Exists(value) then
						begin
							whole = System.IO.File.ReadAllBytes(value)
							@sData = System.Web.HttpUtility.UrlEncode(whole)
						rescue Exception => e
							raise e
						ensure
						end
					else
						raise Exception.new("There was something wrong with the File you selected. Please verify that the file exists.")
					end
				end
			end

			def Caption
				return @sCaption
			end

			def Caption=(value)
				@sCaption = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end
		class Quote < Account
			def initialize()
				@sQuote = ""
				@sSource = ""
			end

			def TheQuote
				return @sQuote
			end

			def TheQuote=(value)
				@sQuote = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end

			def Source
				return @sSource
			end

			def Source=(value)
				@sSource = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end
		class Link < Account
			def initialize()
				@sName = ""
				@sUrl = ""
				@sDescription = ""
			end

			def Name
				return @sName
			end

			def Name=(value)
				@sName = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end

			def Url
				return @sUrl
			end

			def Url=(value)
				@sUrl = value
			end

			def Description
				return @sDescription
			end

			def Description=(value)
				@sDescription = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end
		class Chat < Account
			def initialize()
				@sTitle = ""
				@sChat = ""
			end

			def Title
				return @sTitle
			end

			def Title=(value)
				@sTitle = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end

			def TheChat
				return @sChat
			end

			def TheChat=(value)
				@sChat = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end
		class Video < Account
			def initialize()
				@sEmbed = ""
				@sCaption = ""
			end

			def Embed
				return @sEmbed
			end

			def Embed=(value)
				@sEmbed = value
			end

			def Caption
				return @sCaption
			end

			def Caption=(value)
				@sCaption = System.Web.HttpUtility.UrlEncode(value, Encoding.UTF8)
			end
		end

		def ActivateTumblrEvent(message)
			TumblrArgs = TumblrEventArgs.new(message)
			self.TumblrEvent(self, TumblrArgs)
		end

		def PostIt(data)
			# Generic Post to Tumblr method
			stat = "Success"
			response = nil
			newStream = nil
			# Prepare web request...
			myRequest = WebRequest.Create("http://www.tumblr.com/api/write")
			myRequest.Credentials = CredentialCache.DefaultCredentials
			myRequest.Method = "POST"
			myRequest.ContentType = "application/x-www-form-urlencoded; charset=utf-8"
			#header("Content-Type: text/html; charset=iso-8859-1");            
			myRequest.ContentLength = data.Length
			begin
				newStream = myRequest.GetRequestStream()
				# Send the data.
				newStream.Write(data, 0, data.Length)
				# Get the response
				response = myRequest.GetResponse()
				stat = Convert.ToString(response.StatusCode)
			rescue ProtocolViolationException => ex
				stat = Convert.ToString(ex.Message)
			rescue NotSupportedException => ex
				stat = Convert.ToString(ex.Message)
			rescue WebException => ex
				stat = Convert.ToString(ex.Message)
			rescue Exception => e
				stat = Convert.ToString(e.Message)
			ensure
				if response != nil then
					response.Close()
				end
				if newStream != nil then
					newStream.Close()
				end
				self.ActivateTumblrEvent(stat)
			end
			return stat
		end

		def postText(text)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + text.Email
			postData += "&password=" + text.Password
			postData += "&type=regular"
			if ((text.Title == nil) or (text.Title == "")) and ((text.Body == nil) or (text.Body == "")) then
				raise ArgumentNullException.new()
			else
				if (text.Title != nil) and (text.Title != "") then
					postData += "&title=" + text.Title
				end
				if (text.Body != nil) and (text.Body != "") then
					postData += "&body=" + text.Body
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end

		def postPhoto(photo)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + photo.Email
			postData += "&password=" + photo.Password
			postData += "&type=photo"
			if ((photo.Source == nil) or (photo.Source == "")) and ((photo.Data == nil) or (photo.Data == "")) then
				raise ArgumentNullException.new()
			else
				if (photo.Source != nil) and (photo.Source != "") then
					postData += "&source=" + photo.Source
				else # Don't bother sending a picture if the source is here
					if (photo.Data != nil) and (photo.Data != "") then
						postData += "&data=" + photo.Data
					end
				end
				if (photo.Caption != nil) and (photo.Caption != "") then
					postData += "&caption=" + photo.Caption
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end

		def postQuote(quote)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + quote.Email
			postData += "&password=" + quote.Password
			postData += "&type=quote"
			if (quote.TheQuote == nil) or (quote.TheQuote == "") then
				raise ArgumentNullException.new()
			else
				if (quote.TheQuote != nil) and (quote.TheQuote != "") then
					postData += "&quote=" + quote.TheQuote
				end
				if (quote.Source != nil) and (quote.Source != "") then
					postData += "&source=" + quote.Source
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end

		def postLink(link)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + link.Email
			postData += "&password=" + link.Password
			postData += "&type=link"
			if (link.Url == nil) or (link.Url == "") then
				raise ArgumentNullException.new()
			else
				if (link.Name != nil) and (link.Name != "") then
					postData += "&name=" + link.Name
				end
				if (link.Url != nil) and (link.Url != "") then
					postData += "&url=" + link.Url
				end
				if (link.Description != nil) and (link.Description != "") then
					postData += "&description=" + link.Description
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end

		def postChat(chat)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + chat.Email
			postData += "&password=" + chat.Password
			postData += "&type=conversation"
			if (chat.TheChat == nil) or (chat.TheChat == "") then
				raise ArgumentNullException.new()
			else
				if (chat.Title != nil) and (chat.Title != "") then
					postData += "&title=" + chat.Title
				end
				if (chat.TheChat != nil) and (chat.TheChat != "") then
					postData += "&conversation=" + chat.TheChat
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end

		def postVideo(video)
			enc = Encoding.UTF8.GetEncoder()
			postData = "email=" + video.Email
			postData += "&password=" + video.Password
			postData += "&type=video"
			if (video.Embed == nil) or (video.Embed == "") then
				raise ArgumentNullException.new()
			else
				if (video.Embed != nil) and (video.Embed != "") then
					postData += "&embed=" + video.Embed
				end
				if (video.Caption != nil) and (video.Caption != "") then
					postData += "&caption=" + video.Caption
				end
			end
			postData += "&generator=" + generator
			chr = postData.ToCharArray()
			byteCount = enc.GetByteCount(chr, 0, chr.Length, true)
			data = Array.CreateInstance(Byte, byteCount)
			bytesEncodedCount = enc.GetBytes(chr, 0, chr.Length, data, 0, true)
			return self.PostIt(data)
		end
	end
end
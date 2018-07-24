require "base64"
require "openssl/hmac"

module Thumbor
  class Image
    property meta
    property smart

    def initialize(@path : String)
      @trim    = ""
      @crop    = ""
      @resize  = ""
      @halign  = ""
      @valign  = ""
      @filters = [] of String
      @smart   = false
      @meta    = false
    end

    def trim(color_source : String? = nil, tolerance : Int32? = nil)
      @trim = "trim"
      @trim += ":#{color_source}" if color_source
      @trim += ":#{tolerance}" if tolerance
    end

    def crop(top_left_x = Int32, top_left_y = Int32, bottom_right_x = Int32, bottom_right_y = Int32)
      @crop = "#{top_left_x}x#{top_left_y}:#{bottom_right_x}x#{bottom_right_y}"
    end

    def full_fit_in(width = Int32, height = Int32)
      @resize = "full-fit-in/#{width}x#{height}"
    end

    def fit_in(width = Int32, height = Int32)
      @resize = "fit-in/#{width}x#{height}"
    end

    def resize(width = Int32, height = Int32)
      @resize = "#{width}x#{height}"
    end

    def halign(halign : String)
      @halign = halign
    end

    def valign(valign : String)
      @valign = valign
    end

    def smart_crop
      @smart_crop = true
    end

    def add_filter(name, *arguments)
      @filters << sprintf("filters:%s(%s)", name, arguments.join(", "))
    end

    def metadata_only
      @metadata_only = true
    end

    def generate
      options_to_path
    end

    private def options_to_path
      commands = [] of String

      commands << "meta" if @metadata_only

      commands << @trim    unless @trim == ""
      commands << @crop    unless @crop == ""
      commands << @resize  unless @resize == ""
      commands << @halign  unless @halign == ""
      commands << @valign  unless @valign == ""

      commands << "smart"  if @smart_crop

      commands << @filters.join(":") unless @filters.empty?

      path = (commands << @path).join("/")
      path = signature_for(Thumbor.settings.key, path) + "/#{path}"

      path
    end

    private def signature_for(key, path)
      return Thumbor.settings.key if Thumbor.settings.key == "unsafe"
      Base64.urlsafe_encode(OpenSSL::HMAC.digest(:sha1, key, path))
    end
  end
end

# class StringIO
#   attr_accessor :original_filename
# end
#
# class TempFile
#   attr_accessor :original_filename
# end

module CarrierWave
  class SanitizedFile
    def original_filename=(value)
      @original_filename = value
    end
  end
end
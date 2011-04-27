module OpenShip

  class Sscc

    @company_prefix
    @extension_digit = "1"

    def self.company_prefix
      @company_prefix
    end

    def self.company_prefix=(prefix)
      @company_prefix=prefix
    end

    def self.extension_digit
      @extension_digit
    end

    def self.extension_digit=(digit)
      @extension_digit = digit
    end

    def self.generate_check_digit(string_sequence)
      # It's gotta be a string because of the leading zero possibility
      # in the extension digit.
      unless string_sequence.class <= String
        raise "Can only check string sequences."
      end
      unless string_sequence.length == 17
        raise "Sequence must be 17 characters long"
      end
      sequence = []
      string_sequence.each_char { |chr|
        sequence << chr.to_i
      }

      # See http://www.gs1us.org/solutions_services/tools/check_digit_calculator
      array1 = [sequence[0], sequence[2], sequence[4], sequence[6],
        sequence[8], sequence[10], sequence[12], sequence[14], sequence[16]]
      number1 = (array1.inject(:+) * 3)
      array2 = [sequence[1], sequence[3], sequence[5], sequence[7], sequence[9],
        sequence[11], sequence[13], sequence[15]]
      number2 = array2.inject(:+)
      number3 = number1 + number2
      check_digit = (10 - (number3 % 10)).to_s
    end

    def self.generate_sscc_id(serial_reference)
      if company_prefix.nil?
        raise "Company prefix cannot be nil. Set with OpenShip::Sscc.company_prefix"
      end
      while ((@company_prefix.length + serial_reference.length) < 16)
        serial_reference = "0" + serial_reference
      end
      sequence = @extension_digit + @company_prefix + serial_reference
      check_digit = self.generate_check_digit(sequence)
      sscc = sequence + check_digit
    end

    
  end

end

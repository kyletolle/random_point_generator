require 'bigdecimal'

class RandomPointGenerator
  MAX_DIGITS_OF_PRECISION = 6

  def initialize(sw_point = nil, ne_point = nil)
    sw_point ||= ["-90.0", "-180.0"]
    ne_point ||= ["90.0", "180.0"]

    @sw_point = convert_to_precise_point(sw_point)
    @ne_point = convert_to_precise_point(ne_point)
  end

  def random_point
    y_range = (sw_lat .. ne_lat)
    x_range = (sw_lng .. ne_lng)

    [random_big_decimal(y_range), random_big_decimal(x_range)]
  end

private
  def sw_lat
    @sw_point[0].to_f
  end

  def sw_lng
    @sw_point[1].to_f
  end

  def ne_lat
    @ne_point[0].to_f
  end

  def ne_lng
    @ne_point[1].to_f
  end

  def convert_to_precise_point(imprecise_point)
    imprecise_point.map do |value|
      convert_to_precise_number(value)
    end
  end

  def convert_to_precise_number(imprecise_number)
    # NOTE: Creating a big decimal here with the float itself causes some
    # rounding issues... strange. So we convert to a string.
    BigDecimal.new(imprecise_number.to_s, MAX_DIGITS_OF_PRECISION)
  end

  def random_big_decimal(range)
    # NOTE: We can't use any of the built-in BigDecimal methods to give us a
    # FIXED length number of decimals. Not that I've seen, at least.
    # So we end up doing that truncation ourselves.
    random_float          = rand(range)
    random_decimal        = convert_to_precise_number(random_float)
    decimal_string        = random_decimal.to_s("F")
    dot_position          = decimal_string.index(".")
    last_decimal_position = dot_position + MAX_DIGITS_OF_PRECISION + 1
    if last_decimal_position > decimal_string.length-1
      last_decimal_position = decimal_string.length
    end
    decimal_string.slice(0, last_decimal_position)
  end
end


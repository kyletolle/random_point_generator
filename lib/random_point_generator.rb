require 'bigdecimal'

class RandomPointGenerator
  MAX_DIGITS_OF_PRECISION = 6

  # Accepts strings as well as floats
  # TODO: Convert this to accept a bounding box instead of these points.
  # The points are LAT, LNG, when the bounding box will be passed in like LNG,
  # LAT.
  # bbox = minx, miny, maxx, maxy (min long, min lat, max long, max lat)
  #
  # Switching to the bbox is going to be an enormous change. It'll change the
  # input formats, the code inside, and the return format. Definite a 1.0 or
  # 1.1 release. Good change to change up the specs too. Or maybe throw the
  # old ones out and start fresh. Try to use this as a chance to _really_
  # drive the design and the code with tests, since this codebase isn't too
  # large.
  #
  def initialize(sw_point = nil, ne_point = nil)
    sw_point ||= ["-90.0", "-180.0"]
    ne_point ||= ["90.0", "180.0"]

    # TODO: Instead of working with "precise points", we can work right with
    # the min x, min y, max x, max y.
    @sw_point = convert_to_precise_point(sw_point)
    @ne_point = convert_to_precise_point(ne_point)
  end

  def random_point
    # TODO: Using min x, etc will make a lot more sense here too!
    y_range = (sw_lat .. ne_lat)
    x_range = (sw_lng .. ne_lng)

    [random_big_decimal(y_range), random_big_decimal(x_range)]
  end

private

  #TODO: Why do we need the `.to_f` for all of these? Can't we go ahead and use
  #strings as the intermediary format here? Nope, seems like the floats are
  #needed for the random part.
  #

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

  # TODO: Soon we shouldn't need this right now...
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
    #
    #TODO: Do we want to use something like SecureRandom for a truly random
    #number here? Or heck, should we at least seed the rand?
    #
    #If we wanted to use secure random here, I think we'd need to write our
    #own float random for it.
    #Random integer part. Random decimal part too. But that could also get
    #tricky... Hmmm....
    #
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


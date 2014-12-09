class RandomPointGenerator
  def initialize(sw_point = nil, ne_point = nil)
    sw_point ||= [-90.0, -180.0]
    ne_point ||= [90.0, 180.0]

    @sw_point = sw_point
    @ne_point = ne_point
  end

  def random_point
    y_range = (sw_lat .. ne_lat)
    x_range = (sw_lng .. ne_lng)

    [rand(y_range), rand(x_range)]
  end

private
  def sw_lat
    @sw_point[0]
  end

  def sw_lng
    @sw_point[1]
  end

  def ne_lat
    @ne_point[0]
  end

  def ne_lng
    @ne_point[1]
  end
end


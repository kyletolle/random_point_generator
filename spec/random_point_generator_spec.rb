require 'random_point_generator'

describe RandomPointGenerator do
  shared_examples "generates a valid, random point" do
    it "generates a point" do
      expect(subject).to be_an Array
    end

    it "gives a valid, random latitude" do
      lat = random_point[0]
      expect(lat).to be >= expected_lower_lat_bound
      expect(lat).to be <= expected_upper_lat_bound
    end

    it "gives a valid, random longitude" do
      lng = random_point[1]
      expect(lng).to be >= expected_lower_lng_bound
      expect(lng).to be <= expected_upper_lng_bound
    end
  end

  describe "with no bounding box" do
    let(:generator) { described_class.new }
    subject         { generator }

    describe "#random_point" do
      let(:random_point) { generator.random_point }
      subject            { random_point }

      let(:expected_lower_lat_bound) { -90.0 }
      let(:expected_upper_lat_bound) { 90.0 }

      let(:expected_lower_lng_bound) { -180.0 }
      let(:expected_upper_lng_bound) { 180.0 }

      include_examples "generates a valid, random point"
    end
  end

  describe "with a bounding box" do
    describe "with both sw_point and ne_point" do
      let(:sw_lat) { 5.0 }
      let(:sw_lng) { 50.0 }

      let(:sw_point) { [sw_lat, sw_lng] }

      let(:ne_lat) { 53.4 }
      let(:ne_lng) { 54.87 }

      let(:ne_point) { [ne_lat, ne_lng] }

      let(:generator) { described_class.new(sw_point, ne_point) }
      subject         { generator }

      describe "#random_point" do
        let(:random_point) { generator.random_point }
        subject            { random_point }

        let(:expected_lower_lat_bound) { sw_lat }
        let(:expected_upper_lat_bound) { ne_lat }

        let(:expected_lower_lng_bound) { sw_lng }
        let(:expected_upper_lng_bound) { ne_lng }

        include_examples "generates a valid, random point"
      end
    end

    describe "with valid sw_point and nil ne_point" do
      let(:sw_lat) { 5.0 }
      let(:sw_lng) { 50.0 }

      let(:sw_point) { [sw_lat, sw_lng] }


      let(:ne_point) { nil }

      let(:generator) { described_class.new(sw_point, ne_point) }
      subject         { generator }

      describe "#random_point" do
        let(:random_point) { generator.random_point }
        subject            { random_point }

        let(:expected_lower_lat_bound) { sw_lat }
        let(:expected_upper_lat_bound) { 90.0 }

        let(:expected_lower_lng_bound) { sw_lng }
        let(:expected_upper_lng_bound) { 180.0 }

        include_examples "generates a valid, random point"
      end
    end

    describe "with nil sw_point and nil ne_point" do

      let(:sw_point) { nil }

      let(:ne_lat) { 53.4 }
      let(:ne_lng) { 54.87 }

      let(:ne_point) { [ne_lat, ne_lng] }

      let(:generator) { described_class.new(sw_point, ne_point) }
      subject         { generator }

      describe "#random_point" do
        let(:random_point) { generator.random_point }
        subject            { random_point }

        let(:expected_lower_lat_bound) { -90.0 }
        let(:expected_upper_lat_bound) { ne_lat }

        let(:expected_lower_lng_bound) { -180.0 }
        let(:expected_upper_lng_bound) { ne_lng }

        include_examples "generates a valid, random point"
      end
    end
  end
end


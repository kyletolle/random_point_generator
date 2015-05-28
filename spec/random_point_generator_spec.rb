require 'random_point_generator'

describe RandomPointGenerator do
  shared_examples "generates a valid, random point" do
    let(:max_precision) { RandomPointGenerator::MAX_DIGITS_OF_PRECISION }

    it "generates a point" do
      expect(subject).to be_an Array
    end

    it "gives a valid, random latitude" do
      lat = BigDecimal.new(random_point[0])
      expect(lat).to be >=
        BigDecimal.new(expected_lower_lat_bound, max_precision)
      expect(lat).to be <=
        BigDecimal.new(expected_upper_lat_bound, max_precision)
    end

    it "gives a valid, random longitude" do
      lng = BigDecimal.new(random_point[1])
      expect(lng).to be >=
        BigDecimal.new(expected_lower_lng_bound, max_precision)
      expect(lng).to be <=
        BigDecimal.new(expected_upper_lng_bound, max_precision)
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
      let(:generator) { described_class.new(sw_point, ne_point) }
      subject         { generator }

      describe "with nice, round numbers" do
        let(:sw_lat) { 1.0 }
        let(:sw_lng) { 1.0 }

        let(:sw_point) { [sw_lat, sw_lng] }

        let(:ne_lat) { 2.0 }
        let(:ne_lng) { 2.0 }

        let(:ne_point) { [ne_lat, ne_lng] }


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

      describe "with more digits of precision than necessary" do
        let(:random_point) { generator.random_point }
        subject            { random_point }

        let(:sw_point) { ["1.1111111111", "1.9999999999"] }
        let(:ne_point) { sw_point }

        it "has a latitude with the correct number of decimals" do
          lat = random_point[0]
          lat_decimals = lat.split('.').last

          expect(lat_decimals.length).to eq RandomPointGenerator::MAX_DIGITS_OF_PRECISION
        end

        it "has a longitude with the correct number of decimals" do
          lng = random_point[1]
          lng_decimals = lng.split('.').last

          expect(lng_decimals.length).to eq RandomPointGenerator::MAX_DIGITS_OF_PRECISION
        end
      end
    end

    describe "with valid sw_point and nil ne_point" do
      let(:sw_lat) { 1.0 }
      let(:sw_lng) { 1.0 }

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

      let(:ne_lat) { 1.0 }
      let(:ne_lng) { 1.0 }

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


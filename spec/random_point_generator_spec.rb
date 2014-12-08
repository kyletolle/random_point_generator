require 'random_point_generator'

describe RandomPointGenerator do
  describe "with no bounding box" do
    let(:generator) { described_class.new }
    subject         { generator }

    describe "#random_point" do
      let(:random_point) { generator.random_point }
      subject            { random_point }

      it "generates a point" do
        expect(subject).to be_an Array
      end

      it "gives a valid, random latitude" do
        lat = random_point[0]
        expect(lat).to be >= -90.0
        expect(lat).to be <= 90.0
      end

      it "gives a valid, random longitude" do
        lng = random_point[1]
        expect(lng).to be >= -180.0
        expect(lng).to be <= 180.0
      end
    end
  end

  describe "with a bounding box" do
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

      it "generates a point" do
        expect(subject).to be_an Array
      end

      it "gives a valid, random latitude within the bounding box" do
        lat = random_point[0]
        expect(lat).to be >= sw_lat
        expect(lat).to be <= ne_lat
      end

      it "gives a valid, random logitude within the bounding box" do
        lng = random_point[1]
        expect(lng).to be >= sw_lng
        expect(lng).to be <= ne_lng
      end
    end

  end
end


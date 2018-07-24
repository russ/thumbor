require "./spec_helper"

describe Thumbor do
  path = "path/to/image/file.jpg"

  describe "no url customizations" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.generate.should eq("unsafe/#{path}")
    end
  end

  describe "trim option" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.trim
      image.generate.should eq("unsafe/trim/#{path}")
    end

    it "returns a url with a trim color source" do
      image = Thumbor::Image.new(path)
      image.trim("top-left")
      image.generate.should eq("unsafe/trim:top-left/#{path}")
    end

    it "returns a url with a trim tolerance" do
      image = Thumbor::Image.new(path)
      image.trim("top-left", 255)
      image.generate.should eq("unsafe/trim:top-left:255/#{path}")
    end
  end

  describe "crop" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.crop(10, 10, 100, 100)
      image.generate.should eq("unsafe/10x10:100x100/#{path}")
    end
  end

  describe "full_fit_in" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.full_fit_in(100, 100)
      image.generate.should eq("unsafe/full-fit-in/100x100/#{path}")
    end
  end

  describe "fit_in" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.fit_in(100, 100)
      image.generate.should eq("unsafe/fit-in/100x100/#{path}")
    end
  end

  describe "resize" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.resize(100, 100)
      image.generate.should eq("unsafe/100x100/#{path}")
    end
  end

  describe "halign" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.halign("left")
      image.generate.should eq("unsafe/left/#{path}")
    end
  end

  describe "valign" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.valign("middle")
      image.generate.should eq("unsafe/middle/#{path}")
    end
  end

  describe "smart_crop" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.smart_crop
      image.generate.should eq("unsafe/smart/#{path}")
    end
  end

  describe "metadata_only" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.metadata_only
      image.generate.should eq("unsafe/meta/#{path}")
    end
  end

  describe "overabundance of options" do
    it "returns a url" do
      image = Thumbor::Image.new(path)
      image.halign("center")
      image.valign("middle")
      image.full_fit_in(475, 268)
      image.smart_crop
      image.add_filter("grayscale")
      image.add_filter("contrast", 50)
      image.add_filter("equalize")
      image.add_filter("quality", 20)
      image.generate.should eq("unsafe/full-fit-in/475x268/center/middle/smart/filters:grayscale():filters:contrast(50):filters:equalize():filters:quality(20)/#{path}")
    end
  end
end

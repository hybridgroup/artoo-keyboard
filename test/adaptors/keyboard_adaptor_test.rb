require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/keyboard'

class MockTTY
  attr_reader :chars

  def initialize
    @chars = []
  end

  def get_char
    chars.pop
  end

  # no-op methods
  def configure ; end
  def restore ; end
  def puts ; end
end

describe Artoo::Adaptors::Keyboard do
  before do
    @adaptor = Artoo::Adaptors::Keyboard.new
    @tty = MockTTY.new
    TTY.stubs(:new).returns(@tty)
  end

  describe "#name" do
    it "identifies as 'keyboard'" do
      @adaptor.name.must_equal 'keyboard'
    end
  end

  describe "#connect" do
    before do
      @tty.expects(:configure)
      @adaptor.connect
    end

    it "sets up a TTY" do
      @adaptor.tty.must_equal @tty
    end

    it 'creates a queue' do
      @adaptor.chars.must_be_instance_of Thread::Queue
    end

    it 'creates a buffer array' do
      @buffer = []
    end
  end

  describe "#get_char" do
    before do
      @adaptor.connect
    end

    it "parses chars from the TTY" do
      @tty.chars << "a"
      @adaptor.get_char.must_equal "a"
    end

    it "catches the spacebar" do
      @tty.chars << " "
      @adaptor.get_char.must_equal "space"
    end

    it "passes through escape" do
      @tty.chars << "\e"
      @adaptor.get_char.must_equal "\e"
    end

    describe "arrow keys" do
      it "recognizes the up arrow key" do
        ["A", "[", "\e"].each { |chr| @tty.chars << chr }
        @adaptor.get_char.must_equal "up"
      end

      it "recognizes the down arrow key" do
        ["B", "[", "\e"].each { |chr| @tty.chars << chr }
        @adaptor.get_char.must_equal "down"
      end

      it "recognizes the left arrow key" do
        ["D", "[", "\e"].each { |chr| @tty.chars << chr }
        @adaptor.get_char.must_equal "left"
      end

      it "recognizes the right arrow key" do
        ["C", "[", "\e"].each { |chr| @tty.chars << chr }
        @adaptor.get_char.must_equal "right"
      end
    end
  end
end

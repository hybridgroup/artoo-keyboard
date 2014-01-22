require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a keyboard device
    # @see device documentation for more information
    class Keyboard < Adaptor
      STANDARD_CHARS = %w(
        abcdefghijklmnopqrstuvwxyz
        ABCDEFGHIJKLMNOPQRSTUVWXYZ
        1234567890
      ).join.split('').freeze

      # Creates a connection with device
      # @return [Boolean]
      def connect
        TTY.with_tty do |tty|
          tty.configure
          begin
            loop do
              parse_char tty.get_char
            end
          ensure
            tty.restore
            tty.puts
          end
        end
        super
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
        super
      end

      # Name of device
      # @return [String]
      def name
        "keyboard"
      end

      # Version of device
      # @return [String]
      def version
        Artoo::Keyboard::VERSION
      end

      private

      def parse_char(char)
        p char
      end
    end
  end
end

class TTY < Struct.new(:in_file, :out_file)
  attr_reader :original_stty_state

  def get_char
    in_file.getc
  end

  def puts
    out_file.puts
  end

  def winsize
    out_file.winsize
  end

  def stty(args)
    command("stty #{args}")
  end

  def configure
    @original_stty_state = stty "-g"
    # raw: Disable input and output processing
    # -echo: Don't echo keys back
    # cbreak: Set up lots of standard stuff, including INTR signal on ^C
    stty "raw -echo cbreak"
  end

  def restore
    stty "#{@original_stty_state}"
  end

  def self.with_tty(&block)
    File.open("/dev/tty", "r") do |in_file|
      File.open("/dev/tty", "w") do |out_file|
        tty = TTY.new(in_file, out_file)
        block.call(tty)
      end
    end
  end

  private

  # Run a command with the TTY as stdin, capturing the output via a pipe
  def command(command)
    IO.pipe do |read_io, write_io|
      pid = Process.spawn(command, :in => "/dev/tty", :out => write_io)
      Process.wait(pid)
      raise "Command failed: #{command.inspect}" unless $?.success?
      write_io.close
      read_io.read
    end
  end
end


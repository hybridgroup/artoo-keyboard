require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a keyboard device
    # @see device documentation for more information
    class Keyboard < Adaptor
      KEY_CTRL_C = ?\C-c
      KEY_ESCAPE = 0x1B
      KEY_ARROW_UP = 0x41
      KEY_ARROW_DOWN = 0x42
      KEY_ARROW_RIGHT = 0x43
      KEY_ARROW_LEFT = 0x44

      attr_reader :tty, :chars, :buffer

      # Creates a connection with device
      # @return [Boolean]
      def connect
        @tty = TTY.new
        @tty.configure

        @chars = Queue.new
        @buffer = []

        super
      end

      # Closes connection with device
      # @return [Boolean]
      def disconnect
        tty.restore
        tty.puts

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

      def get_char
        parse_char tty.get_char
        chars.pop
      end

      private

      def quit
        puts "QUITTING"
        tty.restore
        Artoo::Master.stop_work
        exit(0)
      end

      def parse_char(char)
        case char
        when KEY_CTRL_C then quit
        when " " then chars.push("space")
        when KEY_ESCAPE.chr then
          next_char = tty.get_char
          if next_char
            next_char = tty.get_char
            case next_char
            when KEY_ARROW_UP.chr then chars.push('up')
            when KEY_ARROW_DOWN.chr then chars.push('down')
            when KEY_ARROW_RIGHT.chr then chars.push('right')
            when KEY_ARROW_LEFT.chr then chars.push('left')
            end
          else
            chars.push(char) # just escape
          end
        when /[[:print:]]/ then chars.push(char)
        else chars.push(nil) # unknown or non-qwerty char
        end
      end
    end
  end
end

class TTY
  attr_reader :original_stty_state, :in_file, :out_file

  def initialize
    @in_file = File.open("/dev/tty", "r")
    @out_file = File.open("/dev/tty", "w")
  end

  def get_char
    in_file.getc
  end

  def puts
    out_file.puts
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

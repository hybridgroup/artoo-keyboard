require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to a keyboard device
    # @see device documentation for more information
    class Keyboard < Adaptor
      KEY_CTRL_C = ?\C-c

      attr_reader :tty, :chars

      # Creates a connection with device
      # @return [Boolean]
      def connect
        @in_file = File.open("/dev/tty", "r")
        @out_file = File.open("/dev/tty", "w")
        @tty = TTY.new(@in_file, @out_file)

        @tty.configure
        @chars = Queue.new

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

      def parse_char(char)
        case char
        when KEY_CTRL_C then
          Artoo::Master.stop_work
          exit(0)
        when /[[:print:]]/ then chars.push(char)
        else chars.push(nil) # unknown or non-qwerty char
        end
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


require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The keyboard driver behaviors
    class Keyboard < Driver

      # Start driver and any required connections
      def start_driver
        every(interval) do
          p connection.get_char # get the next char if any...
        end

        super
      end

    end
  end
end

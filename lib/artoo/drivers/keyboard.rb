require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The keyboard driver behaviors
    class Keyboard < Driver

      # Public: Start driver and any required connections.
      #
      # Returns null.
      def start_driver
        every(0.05) do
          key = connection.get_char # get the next char if any...
          publish(event_topic_name("key"), key) if key
        end

        super
      end
    end
  end
end

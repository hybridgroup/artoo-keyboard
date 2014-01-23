require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The keyboard driver behaviors
    class Keyboard < Driver

      # Start driver and any required connections
      def start_driver
        every(interval) do
          key = connection.get_char # get the next char if any...
          publish(event_topic_name("key"), key) if key
        end

        super
      end

    end
  end
end

require 'minitest/autorun'
require 'mocha/mini_test'
require 'artoo/robot'

Celluloid.logger = nil

MiniTest::Spec.before do
  Celluloid.shutdown
  Celluloid.boot
end

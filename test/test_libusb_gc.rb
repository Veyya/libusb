# These tests should be started with valgrind to check for
# invalid memmory access.

require "test/unit"
require "libusb"

class TestLibusbGc < Test::Unit::TestCase
  include LIBUSB

  def get_some_endpoint
    Context.new.devices.each do |dev|
      return dev.endpoints.last unless dev.endpoints.empty?
    end
  end

  def test_descriptors
    ep = get_some_endpoint
    ps = ep.wMaxPacketSize
    GC.start
    assert_equal ps, ep.wMaxPacketSize, "GC should not free EndpointDescriptor"
  end
end

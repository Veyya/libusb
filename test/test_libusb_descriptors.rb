require "test/unit"
require "libusb"

class TestLibusb < Test::Unit::TestCase
  include LIBUSB

  attr_accessor :usb

  def setup
    @usb = Context.new
    @usb.debug = 0
  end

  def test_descriptors
    usb.devices.each do |dev|
      assert_match(/Device/, dev.inspect, "Device#inspect should work")
      dev.configurations.each do |config_desc|
        assert_match(/Configuration/, config_desc.inspect, "ConfigDescriptor#inspect should work")
        assert dev.configurations.include?(config_desc), "Device#configurations should include this one"

        config_desc.interfaces.each do |interface|
          assert_match(/Interface/, interface.inspect, "Interface#inspect should work")

          assert dev.interfaces.include?(interface), "Device#interfaces should include this one"
          assert config_desc.interfaces.include?(interface), "ConfigDescriptor#interfaces should include this one"

          interface.alt_settings.each do |if_desc|
            assert_match(/Setting/, if_desc.inspect, "InterfaceDescriptor#inspect should work")

            assert dev.settings.include?(if_desc), "Device#settings should include this one"
            assert config_desc.settings.include?(if_desc), "ConfigDescriptor#settings should include this one"
            assert interface.alt_settings.include?(if_desc), "Inteerface#alt_settings should include this one"

            if_desc.endpoints.each do |ep|
              assert_match(/Endpoint/, ep.inspect, "EndpointDescriptor#inspect should work")

              assert dev.endpoints.include?(ep), "Device#endpoints should include this one"
              assert config_desc.endpoints.include?(ep), "ConfigDescriptor#endpoints should include this one"
              assert interface.endpoints.include?(ep), "Inteerface#endpoints should include this one"
              assert if_desc.endpoints.include?(ep), "InterfaceDescriptor#endpoints should include this one"

              assert_equal if_desc, ep.setting, "backref should be correct"
              assert_equal interface, ep.interface, "backref should be correct"
              assert_equal config_desc, ep.configuration, "backref should be correct"
              assert_equal dev, ep.device, "backref should be correct"

              assert_operator 0, :<, ep.wMaxPacketSize, "packet size should be > 0"
            end
          end
        end
      end
    end
  end

  def test_constants
    assert_equal 7, CLASS_PRINTER, "Printer class id should be defined"
    assert_equal 48, ISO_USAGE_TYPE_MASK, "iso usage type should be defined"
  end
end

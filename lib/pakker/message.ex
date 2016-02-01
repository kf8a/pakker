defmodule Pakker.Message do
  defstruct message_type: nil,
            transaction_id: nil,
            body: nil

  # SerPkt message types
  def message_type_atom(message) do
    case message.message_type do
      0x81 -> :delivery_message
      0x09 -> :hello
      0x89 -> :hello
      0x0e -> :hello_request
      0x0d -> :bye
      0x07 -> :get_settings_command
      0x87 -> :get_settings_response
      0x08 -> :set_settings_command
      0x88 -> :set_settings_response
      0x0f -> :get_devconfig_settings_command
      0x8f -> :get_devconfig_settings_response
      0x10 -> :set_devconfig_settings_command
      0x90 -> :set_devconfig_settings_response
      0x11 -> :get_devconfig_fragment_settings_command
      0x91 -> :get_devconfig_fragment_settings_response
      0x12 -> :set_devconfig_fragment_settings_command
      0x92 -> :set_devconfig_fragment_settings_response
      0x13 -> :devconfig_control_command
      0x93 -> :devconfig_control_response
      #TODO set BMP message types
    end
  end

  def from_bits(bits) do
    << message_type :: size(8),
       transaction_id :: size(8),
       body :: binary >> =  bits


    %Pakker.Message{
      message_type: message_type,
      transaction_id: transaction_id,
      body: body
    }
  end
end

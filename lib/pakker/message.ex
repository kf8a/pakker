defmodule Pakker.Message do
  defstruct message_type: nil,
            transaction_id: nil,
            body: nil

  # SerPkt message types
  def message_type_atom(message) do
    case message.hi_proto_code do
      0 -> pakctrl(message)
      1 -> bmp(message)
    end
  end

  # PakCtrl messages if hiProto == 0
  defp pakctrl(message) do
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
      _ -> :unknown
    end
  end

  #TODO set BMP message types
  defp bmp(message) do
    case message.message_type do
      0xa1 -> :please_wait
      0x17 -> :clock_command
      0x97 -> :clock_response
      0x1c -> :file_download_command
      0x9c -> :file_download_response
      0x1d -> :file_upload_command
      0x9d -> :file_upload_response
      0x1e -> :file_control_command
      0x9e -> :file_control_response
      0x18 -> :get_programming_stats_command
      0x98 -> :get_programming_stats_response
      0x09 -> :collect_data_command
      0x89 -> :collect_data_response
      0x20 -> :one_way_table_definition
      0x14 -> :one_way_data
      0x19 -> :table_control_command
      0x99 -> :table_control_response
      0x1a -> :get_values_command
      0x9a -> :get_values_response
      0x1b -> :set_values_command
      0x9b -> :set_values_response
      _ -> :unknown
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

defmodule Slave do
  #*parse to JSON
  #*calculate forecast
  def start(msg) do
    IO.inspect(msg)
  end
  def json_parse(msg) do
    msg_data = Jason.decode!(msg.data)
    msg_data["message"]
    # try do
    # rescue
    #   Jason.DecodeError -> :panic_msg
    # end
  end

  def weather(data) do
    _atmo_pressure_sensor_1 = data["atmo_pressure_sensor_1"]
    _atmo_pressure_sensor_2 = data["atmo_pressure_sensor_2"]
    _humidity_sensor_1 = data["humidity_sensor_1"]
    _humidity_sensor_2 = data["humidity_sensor_2"]
    _light_sensor_1 = data["light_sensor_1"]
    # light_sensor_2 = data["light_sensor_2"]
    _temperature_sensor_1 = data["temperature_sensor_1"]
    _temperature_sensor_2 = data["temperature_sensor_2"]
    _unix_timestamp_us = data["unix_timestamp_us"]
    _wind_speed_sensor_1 = data["wind_speed_sensor_1"]
    _wind_speed_sensor_2 = data["wind_speed_sensor_2"]
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end

# cond do
#   data == :panic_msg -> recv()
#   true -> [{_id, root}] = :ets.lookup(:buckets_registry, "root_pid")
#   send(root, {:data, data})
# end

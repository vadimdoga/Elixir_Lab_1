defmodule Root do
  def recv do
    receive do
      {:data, msg} -> msg_operations(msg)
      _ -> IO.puts("No match!")
    end
  end

  def msg_operations(msg) do
    weather(msg)
    recv()
  end

  def weather(data) do
    _atmo_pressure_sensor_1 = data["atmo_pressure_sensor_1"]
    _atmo_pressure_sensor_2 = data["atmo_pressure_sensor_2"]
    _humidity_sensor_1 = data["humidity_sensor_1"]
    _humidity_sensor_2 = data["humidity_sensor_2"]
    _light_sensor_1 = data["light_sensor_1"]
    light_sensor_2 = data["light_sensor_2"]
    _temperature_sensor_1 = data["temperature_sensor_1"]
    _temperature_sensor_2 = data["temperature_sensor_2"]
    _unix_timestamp_us = data["unix_timestamp_us"]
    _wind_speed_sensor_1 = data["wind_speed_sensor_1"]
    _wind_speed_sensor_2 = data["wind_speed_sensor_2"]
    IO.puts(light_sensor_2)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :recv, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end

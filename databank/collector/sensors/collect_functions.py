import time
import board
import adafruit_dht

dhtDevice = adafruit_dht.DHT11(board.D4, use_pulseio=False)

def temperature_value():
    print("[LOG] Collecting TEMPERATURE data")
    temperature = 0
    try:
        temperature = dhtDevice.temperature
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
    except Exception as error:
        dhtDevice.exit()
        raise error
    return temperature

def humidity_value():
    print("[LOG] Collecting HUMIDITY data")
    humidity = 0
    try:
        humidity = dhtDevice.humidity
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
    except Exception as error:
        dhtDevice.exit()
        raise error
    return humidity

def pressure_value():
    print("[LOG] Collecting PRESSURE data")

def gas_value():
    print("[LOG] Collecting GAS data")

collect_functions = [temperature_value, humidity_value,
                    pressure_value, gas_value]

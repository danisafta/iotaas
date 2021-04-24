import time
import board
import adafruit_dht


NR_RETRIES = 5
dhtDevice = adafruit_dht.DHT11(board.D4, use_pulseio=False)

def temperature_value():
    print("[LOG] Collecting TEMPERATURE data")
    temperature = 0
    try:
        temperature = dhtDevice.temperature
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        return temperature,error.args[0]
    except Exception as error:
        dhtDevice.exit()
        raise error
        return temperature,error.args[0]
    return temperature,"OK"

def humidity_value():
    print("[LOG] Collecting HUMIDITY data")
    humidity = 0
    try:
        humidity = dhtDevice.humidity
    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        return humidity,error.args[0]
    except Exception as error:
        dhtDevice.exit()
        raise error
        return humidity,error.args[0]
    return humidity,"OK"

def pressure_value():
    print("[LOG] Collecting PRESSURE data")

def gas_value():
    print("[LOG] Collecting GAS data")

def data_average(function):
    ''' 
        Computes the average value of the last NR_RETRIES
        calls and returns it.
        If the underlying function/sensor thow an error/
        exception, it will stop.
    '''
    data_sum = 0
    for i in range(NR_RETRIES):
        value,rmsg = function()
        if rmsg is not "OK":
            return value,rmsg,500
        else:
            data_sum += value
    return data_sum / NR_RETRIES,"OK",200
    
    
collect_functions = [temperature_value, humidity_value,
                    pressure_value, gas_value]

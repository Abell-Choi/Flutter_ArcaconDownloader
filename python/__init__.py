import flask
from module.ArcaManager import ArcaconManager

obj = ArcaconManager('https://arca.live/e/23731')

print(obj.getAllData())
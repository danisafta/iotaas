import os,sys,inspect

currentdir = os.path.dirname(os.path.abspath(
    inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir)

from db.base import Session
from collect_functions import collect_functions

session = Session()
for function in collect_functions:
    function()
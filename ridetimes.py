import sys
import pandas as  pd
from time import gmtime, strftime, sleep
from amusement.parks.universal.IslandsOfAdventure import IslandsOfAdventure
from amusement.parks.seaworld.BuschGardensTampa import BuschGardensTampa
from amusement.parks.seaworld.SeaworldOrlando import SeaworldOrlando
from amusement.parks.disney.DisneylandParis import DisneylandParis

dp = DisneylandParis().rides
ioa = IslandsOfAdventure().rides
sw = SeaworldOrlando().rides

ride_waits = []
for i in range(24):
    for show in dp():
        ride_waits.append({'park': "disneylandparis",
        'date': strftime("%Y-%m-%d", gmtime()),
        'time': strftime("%H:%M:%S", gmtime()),
         'ride': show['name'],
         'isOpen': show['isOpen'],
         'wait' :show['wait']})
    for show in ioa():
        ride_waits.append({'park': "islandsofadventure",
        'date': strftime("%Y-%m-%d", gmtime()),
        'time': strftime("%H:%M:%S", gmtime()),
         'ride': show['name'],
         'isOpen': show['isOpen'],
         'wait' :show['wait']})
    sleep(60*60)
    # or print ioa.shows() if you want show times instead"


ride_frame = pd.DataFrame(ride_waits)
ride_frame.to_csv('../../Data/ride_waits_ihr.csv', sep =',', encoding='utf-8')

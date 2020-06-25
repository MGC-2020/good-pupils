import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime

near = [0,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,0,1,1,1,1,]
light = [40,45,46,65,813,914,1340,1789,219,727,3308,9290,45410,53683,18751,85,40,41,38,2565,2690,2637,2659,1976,2995,2089,1667,1457,2105,5866,4912,1771,3304,1298,3872,1914,2937,1772,4769,11385,25809,26501,2075,620,4055,610,3681,782,438,124,5126,1582,2260,2098,10166,3119,4861,2095,2830,1051,1085,1523,17550,11541,18186,10216,6802,11680,5013,6876,54,0]

fig, (near_ax, light_ax) = plt.subplots(nrows=1, ncols=2, figsize=(12, 5))

time = [datetime.datetime.now() + datetime.timedelta(minutes=-5*i) for i in range(len(light))]
light_ax.plot(time, light)
light_ax.xaxis.set_major_locator(mdates.HourLocator())
light_ax.xaxis.set_major_formatter(mdates.DateFormatter(r'%I %p'))
light_ax.set_title('Amount of light received over the day')

_, near_frequency = np.unique(near, return_counts=True)
near_ax.pie(
	near_frequency, 
	labels=['Good distancing', 'Too near'], 
	colors=['g', 'r'], 
	autopct='%1.1f%%', 
	shadow=True, 
	startangle=180,
)
near_ax.set_title('How frequently you looked at things from a healthy distance')

fig.savefig('test.png')
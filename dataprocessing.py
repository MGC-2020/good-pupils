import numpy as np
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime

MIN_HEALTHY_LIGHT_LEVEL = 1000
INTERVAL_LENGTH = 5 # minutes

near = [0,1,1,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,0,1,1,1,1,]
light = [40,45,46,65,813,914,1340,1789,219,727,3308,9290,45410,53683,18751,85,40,41,38,2565,2690,2637,2659,1976,2995,2089,1667,1457,2105,5866,4912,1771,3304,1298,3872,1914,2937,1772,4769,11385,25809,26501,2075,620,4055,610,3681,782,438,124,5126,1582,2260,2098,10166,3119,4861,2095,2830,1051,1085,1523,17550,11541,18186,10216,6802,11680,5013,6876,54,0]

plt.style.use('dark_background')


def plot_light_graph(light_history):
	time = [datetime.datetime.now() + datetime.timedelta(minutes=-INTERVAL_LENGTH*i) for i in range(len(light_history))]
	fig, light_ax = plt.subplots()

	light_ax.plot(time, light_history, label="Amount of light received")

	transform=light_ax.get_xaxis_transform()
	light_ax.axhline(MIN_HEALTHY_LIGHT_LEVEL, linestyle='--', label="Minimum healthy light level")

	light_ax.legend()

	light_ax.xaxis.set_major_locator(mdates.HourLocator())
	light_ax.xaxis.set_major_formatter(mdates.DateFormatter(r'%I %p'))

	graph_name = 'plots/light-graph.png'
	graph_path = f'static/{graph_name}'
	fig.savefig(graph_path)
	
	plt.close(fig)
	return graph_name


def get_outdoor_time(light_history):
	outdoor = np.array(light_history) > MIN_HEALTHY_LIGHT_LEVEL
	return np.count_nonzero(outdoor) * INTERVAL_LENGTH


def plot_near_frequency_pie(near_history):
	_, near_frequency = np.unique(near_history, return_counts=True)

	fig, near_ax = plt.subplots()
	near_ax.pie(
		near_frequency, 
		labels=['Good distancing', 'Too near'], 
		colors=['g', 'r'], 
		autopct='%1.1f%%', 
		shadow=True, 
		startangle=180,
	)
	graph_name = 'plots/near-pie.png'
	graph_path = f'static/{graph_name}'
	fig.savefig(graph_path)

	plt.close(fig)
	return graph_name


def plot_near_graph(near_history):
	time = [datetime.datetime.now() + datetime.timedelta(minutes=-INTERVAL_LENGTH*i) for i in range(len(near_history)+1)]
	time = np.array(time)

	near_array = np.array(near_history)

	fig, near_ax = plt.subplots()

	near_ax.set_xlim(time[0], time[-1])

	too_near_regions = [
		near_ax.axvspan(time[i], time[i+1], color='red', alpha=0.5) 
		for i, too_near in enumerate(near_array) 
		if too_near
	]
	too_near_regions[0].set_label("Too close")
	healthy_distance_regions = [
		near_ax.axvspan(time[i], time[i+1], color='green', alpha=0.5) 
		for i, too_near in enumerate(near_array) 
		if not too_near
	]
	healthy_distance_regions[0].set_label("Healthy distancing")

	near_ax.xaxis.set_major_locator(mdates.HourLocator())
	near_ax.xaxis.set_major_formatter(mdates.DateFormatter(r'%I %p'))

	near_ax.legend()
	
	graph_name = 'plots/near-graph.png'
	graph_path = f'static/{graph_name}'
	
	fig.savefig(graph_path)
	return graph_name


def get_near_frequency(near_history):
	return np.count_nonzero(near_history)

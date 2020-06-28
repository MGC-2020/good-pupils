from flask import Flask, render_template, request, redirect, url_for

import dataprocessing

app = Flask(__name__)
papers = None
categories = None


@app.route("/")
def home():
    csv_file_name = request.args.get('csv_file_name')
    light_history, near_history = dataprocessing.process_csv(csv_file_name)
    
    light_graph_name = dataprocessing.plot_light_graph(light_history)
    outdoor_time = dataprocessing.get_outdoor_time(light_history)
    near_frequency_pie_name = dataprocessing.plot_near_frequency_pie(near_history)
    near_frequency = dataprocessing.get_near_frequency(near_history)
    near_graph_name = dataprocessing.plot_near_graph(near_history)
    return render_template(
        'index.html', 
        light_graph_name=light_graph_name,
        outdoor_time=outdoor_time,
        near_frequency=near_frequency,
        near_frequency_pie_name=near_frequency_pie_name,
        near_graph_name=near_graph_name,
    )

if __name__ == "__main__":
    app.run('127.0.0.1', debug=True)

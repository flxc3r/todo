from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import uuid
import random

app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///db.sqlite3"
db = SQLAlchemy(app)

def generate_id():
    return str(uuid.uuid4())

def now_without_microsecond():
    return datetime.now().replace(microsecond=0)

class Task(db.Model):
    id = db.Column(db.String(36), primary_key=True, default=generate_id)
    description = db.Column(db.String(100))
    done = db.Column(db.Boolean, default=False)
    ts = db.Column(db.DateTime, default=now_without_microsecond)


@app.route("/task/create", methods=["POST"])
def create_task():
    if request.method == 'POST':
        t = Task(description=request.form['task-description'])
        db.session.add(t)
        db.session.commit()

        return redirect(url_for('index'))


@app.route("/task/create_some", methods=["GET"])
def create_some_tasks():
    
    tasks_description = [
        "Water the plants 🌿💧",
        "Do laundry 🧺",
        "Walk the dog 🐕",
        "clean kitchen 🔪",
        "Clean car 🧽 🚗",
        "Mopping floors",
        "Mowing the lawn 🏡",
        "Weeding the garden 👨‍🌾",
        "Taking out the trash",
        "Wipe down wood furniture with cleaners",
        "Wash mattress covers, pillow covers, comforters and duvets 🛌",
        "Clean the inside of oven",
        "Wipe down baseboards and moldings, doors and door frames 🚪",
        "Wash ceiling light fixtures, and wipe fan blades",
        "Clean inside the dishwasher with a cleaner recommended by the manufacturer 🍽",
        "Dust, vacuum or wash window coverings 🏠",
        "Wipe light switches, door handles and the surrounding wall area 💡",
        "Answer emails 📧",
        "Prepare meeting 💼",
        "Review tomorrow's presentation 📊📈",
        "Order laptop for incoming intern 💻",
    ]

    for description in random.choices(tasks_description, k=5):
        t = Task(description=description)
        db.session.add(t)
    
    db.session.commit()

    return redirect(url_for('index'))


@app.route("/task/delete", methods=["GET"])
def delete_task():
    if request.method == 'GET':
        t = Task.query.get(request.args['id'])
        
        db.session.delete(t)
        db.session.commit()

        return redirect(url_for('index'))


@app.route("/tasks/delete", methods=["GET"])
def delete_tasks():
    if request.method == 'GET':
        Task.query.delete()
        db.session.commit()
        return redirect(url_for('index'))



@app.route("/task/done", methods=["GET"])
def done_task():
    if request.method == 'GET':
        t = Task.query.get(request.args['id'])
        t.done = not t.done
        db.session.commit()

        return redirect(url_for('index'))

@app.route("/task/update", methods=["GET", "POST"])
def update_task():
    t = Task.query.get(request.args['id'])
    
    if request.method == 'POST':
        t.description = request.form['description']
        db.session.commit()
        return redirect(url_for('index'))

    return render_template('update_task.html', task=t)


@app.route('/', methods=["GET"])
def index():
    tasks = Task.query.order_by(Task.ts.desc()).all()
    return render_template("index.html", tasks=tasks)


@app.route('/tiles', methods=["GET"])
def index_tiles():
    tasks = Task.query.order_by(Task.ts.desc()).all()
    return render_template("index_tiles.html", tasks=tasks)

if __name__ == "__main__":
    app.run(debug=True)


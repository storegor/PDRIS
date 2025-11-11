
import os

import psycopg2
from flask import Flask, render_template_string

app = Flask(__name__)


def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        database=os.environ.get("DB_NAME"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
    )
    return conn


@app.route("/")
def hello_world():
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("INSERT INTO messages (content) VALUES (%s)", ("Hello from Flask!",))
        conn.commit()

        cur.execute("SELECT id, content, timestamp FROM messages ORDER BY timestamp DESC;")
        messages = cur.fetchall()

        cur.close()
        conn.close()

        html_response = """<!DOCTYPE html>
<html>
<head>
    <title>Flask & PostgreSQL</title>
    <style>
        body { font-family: sans-serif; margin: 2em; }
        h1 { color: #333; }
        ul { list-style-type: none; padding: 0; }
        li { background: #f4f4f4; margin-bottom: 0.5em; padding: 0.8em; border-radius: 5px; }
        .timestamp { font-size: 0.8em; color: #777; }
    </style>
</head>
<body>
    <h1>Messages from PostgreSQL</h1>
    <ul>
        {% for msg in messages %}
            <li>
                {{ msg[1] }} <br>
                <span class="timestamp">ID: {{ msg[0] }} - {{ msg[2] }}</span>
            </li>
        {% endfor %}
    </ul>
    <p>New message added on each refresh!</p>
</body>
</html>"""

        return render_template_string(html_response, messages=messages)
    except Exception as e:
        return f"Error connecting to database or interacting with messages table: {e}"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

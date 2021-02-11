from flesk import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("myweb.html")

if __name__ == "__main__":
    app.run(debug=True)
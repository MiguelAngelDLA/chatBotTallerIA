from openai import OpenAI
import os
from dotenv import load_dotenv
from flask import Flask, request
from flask_cors import CORS
    
load_dotenv()

app = Flask(__name__)


CORS(app, resources={r"/*": {"origins": "*"}})
api_key = os.environ.get("OPENAI_API_KEY")

client = OpenAI(api_key = os.environ.get("OPENAI_API_KEY"))


@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    respuesta = client.chat.completions.create(
        model = "gpt-3.5-turbo",
        messages = [
            {"role": "system", "content": "Eres un asistente de Series, tu objetivo es ayudar a los usuarios a que se entretengan, se cautivador, y no respondas absolutamente nada que no tenga que ver con las Series, Si la pregunta no está relacionada con la series, no contestes"},
            {"role": "user", "content": data['mensaje']},
        ])
    return respuesta.choices[0].message.content


if __name__== '__main__':
    app.run(debug=True)
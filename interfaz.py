import streamlit as st
import requests


entrada = st.chat_input("Escribe algo")

salida = requests.post("http://localhost:5000/chat", json={"mensaje": entrada}).text

st.write(salida)
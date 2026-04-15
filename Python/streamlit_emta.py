import streamlit as st
import pandas as pd
import duckdb

import matplotlib.pyplot as plt
import seaborn as sns

st.write("# Ettevõtluse statistika maakonniti") # kuvame streamlit veebilehele pealkirja

data = pd.read_csv("emta_data.csv")

col1, col2 = st.columns(2)

with col1:
    aasta = st.selectbox("Aaasta", options=sorted(data["aasta"].unique(), reverse=True))

with col2:
    kvartal = st.selectbox("Kvartal", options=duckdb.sql(f"SELECT DISTINCT kvartal FROM data WHERE aasta = {aasta} ORDER BY kvartal DESC")) # see funktsioon
# võtab välja tühjad kvartalid... lihtsam variant oli näidata alati nelja kvartalit: ...options=[1, 2, 3, 4])

# Üksteise all pikad koledad ribad !!!
# aasta = st.selectbox("Aaasta", options=sorted(data["aasta"].unique(), reverse=True))
# kvartal = st.selectbox("Kvartal", options=[1, 2, 3, 4])

count_by_county = duckdb.sql(f"""
    SELECT maakond, count(DISTINCT registrikood) AS ettevotete_arv
    FROM data
    WHERE aasta = {aasta} AND kvartal = {kvartal} -- saab ka siia lisada ...AND maakond NOT NULL
    GROUP BY maakond
    HAVING maakond NOT NULL
    ORDER BY ettevotete_arv DESC
""").df()

st.bar_chart(count_by_county, y="ettevotete_arv", x="maakond", sort=False, horizontal=True) # streamlit'e sisseehitatud graafik !!!,
# kui tahame graafikut teistpidi, lisame arhumendi "horisontal"=True

# Selle graafiku probleem on, et võtab ettevõtete topeltread, kuna meil on iga kvartal eraldi reana
# fig = plt.figure(figsize=(10, 4)) # anname tühja paberilehe
# ax = sns.countplot(data, y="maakond") # koostame graafiku
# ax.set_title("Tegutsevate ettevõtete arv maakondade lõikes") # pealkirja lisamine graafikule
# st.pyplot(fig) # kuvame streamlit veebilehele

"See on testtabel"

fig = plt.figure(figsize=(10, 4))
ax = sns.barplot(count_by_county, y="ettevotete_arv", x="maakond") # seaborn'i graafik !!!
ax.set_title("Tegutsevate ettevõtete arv maakondade lõikes")
st.pyplot(fig)

maakond = st.selectbox("Maakond", options=data["maakond"].unique()) # maakondade rippmenüü

st.write(duckdb.sql(f"""
    SELECT
        kov,
        count(DISTINCT registrikood) AS ettevotete_arv,
        round(avg(kaive) / 3)::int AS keskmine_kuine_kaive,
        round(avg(kaive))::int AS keskmine_kvartaalne_kaive
    FROM data
    WHERE aasta = {aasta} AND kvartal = {kvartal} AND maakond = '{maakond}'
    GROUP BY kov
    ORDER BY keskmine_kuine_kaive DESC
""").df())

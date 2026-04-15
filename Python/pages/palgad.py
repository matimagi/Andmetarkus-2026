import streamlit as st

import pandas as pd
import duckdb

"# Palgad tööstusharude lõikes"

data = pd.read_csv("emta_data.csv")

TAX_PERCENTAGE = 0.338 # konstandid, muutujad mida ei muudeta või muudetakse väga harva

salary_stats = duckdb.sql(f"""
    SELECT
        tegevusala,
        round(avg(toojoumaksud / {TAX_PERCENTAGE} / tootajate_arv / 3), 0) AS keskmine_palk
    FROM data
    WHERE aasta = 2026 AND kvartal = 1 AND tegevusala IS NOT NULL
    GROUP BY tegevusala
    ORDER BY keskmine_palk DESC
""").df()

st.write(salary_stats)
""
""
""
st.bar_chart(salary_stats, x="tegevusala", y="keskmine_palk", sort=False, horizontal=True) # horizontal=True'ga muudame telgede asetust...
# sort=False'ga muudame järjestust

# nii saab kahele tab’ile graafiku ja tabeli
# tab1, tab2 = st.tabs(["Graafik", "Tabel"])
# tab1.bar_chart(salary_stats, x="Peamine tegevusala", y="Keskmine palk", sort=False, horizontal=True)
# tab2.write(salary_stats)

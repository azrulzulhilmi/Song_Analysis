# 🎤 Ariana Grande Lyrics Analysis with NLP & Sentiment Techniques

<p align="center">
  <img src="plots/ariana_header.jfif" alt="Ariana Grande Banner" width="35%">
</p>

[![R](https://img.shields.io/badge/R-4.3.1-blue.svg)](https://www.r-project.org/)  
[![Text Mining](https://img.shields.io/badge/Text%20Mining-TM%20%26%20Tidytext-purple)](https://cran.r-project.org/web/packages/tm/index.html)  
[![Sentiment](https://img.shields.io/badge/Sentiment-Bing%20%26%20NRC%20Lexicons-red)](https://saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm)  
[![Platform](https://img.shields.io/badge/Platform-RStudio-orange.svg)](https://posit.co/)

---

## 📌 Overview

This project explores five popular **Ariana Grande** songs using **Natural Language Processing (NLP)** to understand emotion, tone, and stylistic patterns embedded in her lyrics. The project compares traditional stopword removal with custom stopword strategies to analyze how they influence interpretation and sentiment analysis.

---

## 🎶 Songs Included

<div align="center">

| Song Title             | Theme                        |
|------------------------|------------------------------|
| 7 Rings                | Friendship & Empowerment     |
| No Tears Left to Cry   | Emotional Recovery           |
| Into You               | Romantic Desire              |
| God Is a Woman         | Feminine Power & Identity    |
| Get Well Soon          | Mental Health & Healing      |

</div>

---

## 🧰 Methods Used

- **Data Preprocessing**: Lowercasing, punctuation/number removal, whitespace stripping
- **Stopword Handling**: Comparison of default stopwords vs. custom domain-specific list
- **Visualizations**: Word clouds, bar plots, faceted word frequency
- **Sentiment Analysis**: 
  - **Bing Lexicon** for polarity
  - **NRC Lexicon** for emotion profiling

---

## 🔍 Custom Stopword Strategy

<div align="center">

| 🔹 Default Stopwords | 🔸 Custom Stopwords |
|---------------------|---------------------|
| e.g., the, is, and  | aint, gotta, yeah, want, just, im, get |

</div>

---

## 📊 Key Visualizations

### 📌 Top Words Comparison (Without vs With Custom Stopwords)

<p align="center">
  <img src="plots/bar_compare_top_words.png" alt="Top Word Frequencies" width="800">
</p>

---

### ☁️ Word Clouds

| No Custom Stopwords | With Custom Stopwords |
|---------------------|------------------------|
| ![no_stop](plots/wordcloud_no_custom.png) | ![yes_stop](plots/wordcloud_with_custom.png) |

---

### 💬 Top 10 Words by Song

<p align="center">
  <img src="plots/top10_words_per_song.png" alt="Top Words by Song" width="700">
</p>

---

## 📈 Sentiment Analysis Results

### 🟥 Bing Lexicon – Net Sentiment by Song

<p align="center">
  <img src="plots/bing_sentiment_plot.png" alt="Bing Sentiment" width="600">
</p>

- **Get Well Soon** has the highest net positive sentiment
- **7 Rings** shows the lowest, due to more assertive, bold terms

---

### 🌈 NRC Emotion Lexicon – Emotion Distribution

<p align="center">
  <img src="plots/nrc_emotion_plot.png" alt="NRC Emotion" width="600">
</p>

- **Trust**, **Joy**, and **Anticipation** are most dominant
- Negative emotions like **fear** and **sadness** are present but less prominent

---

## 🧠 Insights

- Custom stopwords improve semantic clarity and reduce filler noise
- Ariana Grande’s lyrics strongly convey **emotional resilience**, **empowerment**, and **healing**
- NRC emotion profile confirms themes of **self-expression**, **confidence**, and **personal growth**

---

## 👨‍🎓 Author 

**Author:** Azrul Zulhilmi Ahmad Rosli

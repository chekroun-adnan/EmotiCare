package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;

import java.time.LocalDate;

public class MoodForecast {
    @Id
    private String forecastId;
    @DBRef
    private User user;
    private LocalDate date;
    private Double predictedMoodScore;
    private Double confidence;
    private String modelVersion;

    public String getModelVersion() {
        return modelVersion;
    }

    public void setModelVersion(String modelVersion) {
        this.modelVersion = modelVersion;
    }

    public Double getConfidence() {
        return confidence;
    }

    public void setConfidence(Double confidence) {
        this.confidence = confidence;
    }

    public Double getPredictedMoodScore() {
        return predictedMoodScore;
    }

    public void setPredictedMoodScore(Double predictedMoodScore) {
        this.predictedMoodScore = predictedMoodScore;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getForecastId() {
        return forecastId;
    }

    public void setForecastId(String forecastId) {
        this.forecastId = forecastId;
    }
}

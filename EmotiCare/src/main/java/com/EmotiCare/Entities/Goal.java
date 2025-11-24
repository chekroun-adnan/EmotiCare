package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Document(collection = "goals")
public class Goal {

    @Id
    private String goalId;
    @DBRef
    private User user;

    private String title;
    private String description;
    private String status;
    private String recommendedBy;
    private Double estimatedBenefit;
    private LocalDate startDate;
    private LocalDate endDate;

    public String getGoalId() {
        return goalId;
    }

    public void setGoalId(String goalId) {
        this.goalId = goalId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRecommendedBy() {
        return recommendedBy;
    }

    public void setRecommendedBy(String recommendedBy) {
        this.recommendedBy = recommendedBy;
    }

    public Double getEstimatedBenefit() {
        return estimatedBenefit;
    }

    public void setEstimatedBenefit(Double estimatedBenefit) {
        this.estimatedBenefit = estimatedBenefit;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
}

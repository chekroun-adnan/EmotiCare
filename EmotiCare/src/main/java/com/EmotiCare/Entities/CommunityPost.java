package com.EmotiCare.Entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.List;

@Document(collection = "community_posts")
public class CommunityPost {

    @Id
    private String postId;
    private String content;
    private LocalDate date;
    private int likes;

    @DBRef
    private User user;

    @DBRef
    private List<CommunityPost> replies;

    public String getPostId() { return postId; }
    public void setPostId(String postId) { this.postId = postId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public int getLikes() { return likes; }
    public void setLikes(int likes) { this.likes = likes; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public List<CommunityPost> getReplies() { return replies; }
    public void setReplies(List<CommunityPost> replies) { this.replies = replies; }
}


package com.EmotiCare.Services;

import com.EmotiCare.Entities.AllInteractionHistory;
import com.EmotiCare.Entities.User;
import com.EmotiCare.Repositories.AllInteractionHistoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AllInteractionHistoryService {

    private final AllInteractionHistoryRepository allRepo;
    private final AuthService authService;

    public AllInteractionHistoryService(AllInteractionHistoryRepository allRepo, AuthService authService) {
        this.allRepo = allRepo;
        this.authService = authService;
    }

    public AllInteractionHistory createEmptyHistory(String userId) {
        AllInteractionHistory h = new AllInteractionHistory();
        h.setUserId(userId);
        h.setMoodIds(List.of());
        h.setJournalIds(List.of());
        h.setMessageIds(List.of());
        h.setHabitEntryIds(List.of());
        h.setGoalIds(List.of());
        return allRepo.save(h);
    }

    public Optional<AllInteractionHistory> getHistory(String userId) {
        User currentUser = authService.getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new RuntimeException("Unauthorized");
        }

        List<AllInteractionHistory> list = allRepo.findByUserId(userId);
        if (list.isEmpty()) return Optional.empty();
        return Optional.of(list.get(0));
    }

    public AllInteractionHistory addMoodToHistory(String historyId, String moodId) {
        AllInteractionHistory h = allRepo.findById(historyId)
                .orElseThrow(() -> new RuntimeException("History not found"));

        User currentUser = authService.getCurrentUser();
        if (!h.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        List<String> moods = h.getMoodIds();
        moods.add(moodId);
        h.setMoodIds(moods);
        return allRepo.save(h);
    }

    public AllInteractionHistory addJournalToHistory(String historyId, String journalId) {
        AllInteractionHistory h = allRepo.findById(historyId)
                .orElseThrow(() -> new RuntimeException("History not found"));

        User currentUser = authService.getCurrentUser();
        if (!h.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        List<String> journals = h.getJournalIds();
        journals.add(journalId);
        h.setJournalIds(journals);
        return allRepo.save(h);
    }

    public AllInteractionHistory addMessageToHistory(String historyId, String messageId) {
        AllInteractionHistory h = allRepo.findById(historyId)
                .orElseThrow(() -> new RuntimeException("History not found"));

        User currentUser = authService.getCurrentUser();
        if (!h.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        List<String> messages = h.getMessageIds();
        messages.add(messageId);
        h.setMessageIds(messages);
        return allRepo.save(h);
    }

    public AllInteractionHistory save(AllInteractionHistory history) {
        User currentUser = authService.getCurrentUser();
        if (!history.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return allRepo.save(history);
    }

    public void deleteHistory(String id) {
        AllInteractionHistory h = allRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("History not found"));

        User currentUser = authService.getCurrentUser();
        if (!h.getUserId().equals(currentUser.getId())) {
            throw new RuntimeException("Unauthorized");
        }

        allRepo.deleteById(id);
    }
}

package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.StatusDTOtoStatus;
import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.StatusRepository;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class StatusService {

    private final StatusRepository statusRepository;
    private final StatusDTOtoStatus statusMapperIn;
    private final StatusToStatusDTO statusMapperOut;
    private final UserService userService;

    public StatusService(StatusRepository statusRepository, StatusDTOtoStatus statusMapperIn, StatusToStatusDTO statusMapperOut, UserService userService) {
        this.statusRepository = statusRepository;
        this.statusMapperIn = statusMapperIn;
        this.statusMapperOut = statusMapperOut;
        this.userService = userService;
    }

    public List<Status> findAll() {;
        return this.statusRepository.findAll();
    }

    public Status createStatus(StatusDTO statusDTO) {
        Status status = statusMapperIn.map(statusDTO);
        return this.statusRepository.saveAndFlush(status);
    }

    public List<Status> findAllStatusesByCreatorId(Long id) {
        return this.statusRepository.findAllByCreatorId(id);
    }

    public List<Status> findAllStatusesBySubscriberUserName(String userName) {
        List<String> following = this.userService.findAllFollowing(userName);
        List<Status> statuses = new ArrayList<Status>();
        for (String u : following) {
            User user = this.userService.findUserByUserName(u);
            List<Status> followedStatuses = this.findAllStatusesByCreatorId(user.getId());
            statuses.addAll(followedStatuses);
        }
        List<Status> orderedStatuses = statuses.stream()
                .sorted(statusComparator())
                .collect(Collectors.toList());
        return orderedStatuses;
    }

    public void deleteStatus(Long statusId) {
        statusRepository.deleteById(statusId);
    }

    public Optional<Boolean> changeFavorite(Long statusId, String userName) {
        Optional<Status> optionalStatus = statusRepository.findByIdWithFavorites(statusId);
        User user = userService.findUserByUserName(userName);

        if (!optionalStatus.isPresent()) {
            return Optional.empty();
        }

        Status status = optionalStatus.get();

        if (status.getFavorites().contains(user)) {
            status.getFavorites().remove(user);
            statusRepository.saveAndFlush(status);
            return Optional.of(false);
        } else {
            status.getFavorites().add(user);
            statusRepository.saveAndFlush(status);
            return Optional.of(true);
        }
    }

    private Comparator<Status> statusComparator() {

        return new Comparator<Status>() {
            @Override
            public int compare(Status status1, Status status2) {
                return status2.getCreationDate().compareTo(status1.getCreationDate());
            }
        };

    }
}

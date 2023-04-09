package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.StatusDTOtoStatus;
import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.StatusRepository;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class StatusService {

    private final StatusRepository repository;
    private final StatusDTOtoStatus mapperIn;
    private final StatusToStatusDTO mapperOut;
    private final UserService userService;

    public StatusService(StatusRepository repository, StatusDTOtoStatus mapperIn, StatusToStatusDTO mapperOut, UserService userService) {
        this.repository = repository;
        this.mapperIn = mapperIn;
        this.mapperOut = mapperOut;
        this.userService = userService;
    }

    public List<Status> findAll() {;
        return this.repository.findAll();
    }

    public Status createStatus(StatusDTO statusDTO) {
        Status status = mapperIn.map(statusDTO);
        return this.repository.saveAndFlush(status);
    }

    public List<Status> findAllStatusesByCreatorId(Long id) {
        return this.repository.findAllByCreatorId(id);
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

    private Comparator<Status> statusComparator() {

        return new Comparator<Status>() {
            @Override
            public int compare(Status status1, Status status2) {
                return status2.getCreationDate().compareTo(status1.getCreationDate());
            }
        };

    }
}

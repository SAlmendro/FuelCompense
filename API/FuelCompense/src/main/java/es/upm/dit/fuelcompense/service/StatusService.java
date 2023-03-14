package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.StatusDTOtoStatus;
import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.repository.StatusRepository;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StatusService {

    private final StatusRepository repository;
    private final StatusDTOtoStatus mapperIn;
    private final StatusToStatusDTO mapperOut;

    public StatusService(StatusRepository repository, StatusDTOtoStatus mapperIn, StatusToStatusDTO mapperOut) {
        this.repository = repository;
        this.mapperIn = mapperIn;
        this.mapperOut = mapperOut;
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
}

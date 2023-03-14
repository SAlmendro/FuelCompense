package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.StatusInDTOtoStatus;
import es.upm.dit.fuelcompense.mapper.StatusToStatusOutDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.repository.StatusRepository;
import es.upm.dit.fuelcompense.service.dto.StatusInDTO;
import es.upm.dit.fuelcompense.service.dto.StatusOutDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class StatusService {

    private final StatusRepository repository;
    private final StatusInDTOtoStatus mapperIn;
    private final StatusToStatusOutDTO mapperOut;

    public StatusService(StatusRepository repository, StatusInDTOtoStatus mapperIn, StatusToStatusOutDTO mapperOut) {
        this.repository = repository;
        this.mapperIn = mapperIn;
        this.mapperOut = mapperOut;
    }

    public List<Status> findAll() {;
        return this.repository.findAll();
    }

    public Status createStatus(StatusInDTO statusInDTO) {
        Status status = mapperIn.map(statusInDTO);
        return this.repository.saveAndFlush(status);
    }

    public List<Status> findAllStatusesByCreatorId(Long id) {
        return this.repository.findAllByCreatorId(id);
    }
}

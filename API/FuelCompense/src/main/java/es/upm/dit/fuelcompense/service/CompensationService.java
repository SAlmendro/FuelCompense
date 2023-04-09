package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.CompensationDTOtoCompensation;
import es.upm.dit.fuelcompense.mapper.CompensationToCompensationDTO;
import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.repository.CompensationRepository;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompensationService {

    private final CompensationRepository repository;
    private final CompensationDTOtoCompensation mapperIn;
    private final CompensationToCompensationDTO mapperOut;
    private final UserService userService;

    public CompensationService(CompensationRepository repository, CompensationDTOtoCompensation mapperIn, CompensationToCompensationDTO mapperOut, UserService userService) {
        this.repository = repository;
        this.mapperIn = mapperIn;
        this.mapperOut = mapperOut;
        this.userService = userService;
    }

    public List<Compensation> findAll() {;
        return this.repository.findAll();
    }

    public Compensation createCompensation(CompensationDTO compensationDTO, String userName) {
        Compensation compensation = mapperIn.map(compensationDTO);
        compensation.setUser(userService.findUserByUserName(userName));
        return this.repository.saveAndFlush(compensation);
    }

    public List<Compensation> findAllCompensationsByUserId(Long id) {
        return this.repository.findAllByUserId(id);
    }
}

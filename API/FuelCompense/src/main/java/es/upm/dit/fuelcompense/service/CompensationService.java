package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.CompensationDTOtoCompensation;
import es.upm.dit.fuelcompense.mapper.CompensationToCompensationDTO;
import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.CompensationRepository;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompensationService {

    private final CompensationRepository compensationRepository;
    private final CompensationDTOtoCompensation compensationMapperIn;
    private final CompensationToCompensationDTO compensationMapperOut;
    private final UserService userService;

    public CompensationService(CompensationRepository compensationRepository, CompensationDTOtoCompensation compensationMapperIn, CompensationToCompensationDTO compensationMapperOut, UserService userService) {
        this.compensationRepository = compensationRepository;
        this.compensationMapperIn = compensationMapperIn;
        this.compensationMapperOut = compensationMapperOut;
        this.userService = userService;
    }

    public Compensation createCompensation(CompensationDTO compensationDTO, String userName) {
        Compensation compensation = compensationMapperIn.map(compensationDTO);
        compensation.setUser(userService.findUserByUserName(userName));
        return this.compensationRepository.saveAndFlush(compensation);
    }

    public Compensation updateCompensation(CompensationDTO compensationDTO, String userName) {
        Compensation compensation = compensationMapperIn.map(compensationDTO);
        User creator = userService.findUserByUserName(userName);
        Compensation compensationInternal = compensationRepository.findByiOSidAndUser(compensation.getIOSid(), creator);
        compensation.setId(compensationInternal.getId());
        compensation.setUser(creator);
        return this.compensationRepository.saveAndFlush(compensation);
    }

    public List<Compensation> findAllCompensationsByUserId(Long id) {
        return this.compensationRepository.findAllByUserId(id);
    }

    public void deleteCompensation(String iOSid, String userName) {
        User user = userService.findUserByUserName(userName);
        Compensation compensation = compensationRepository.findByiOSidAndUser(iOSid, user);
        compensationRepository.delete(compensation);
    }

    public void deleteAllByUserName(String userName) {
        User user = userService.findUserByUserName(userName);
        List<Compensation> compensations = compensationRepository.findAllByUserId(user.getId());
        for(Compensation compensation : compensations) {
            compensationRepository.delete(compensation);
        }
    }
}

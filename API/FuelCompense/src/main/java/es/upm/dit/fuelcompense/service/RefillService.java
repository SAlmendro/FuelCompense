package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.RefillDTOtoRefill;
import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.entity.Refill;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.RefillRepository;
import es.upm.dit.fuelcompense.service.dto.RefillDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RefillService {

    private RefillRepository refillRepository;
    private RefillDTOtoRefill refillMapperIn;
    private UserService userService;

    public RefillService(RefillRepository refillRepository, RefillDTOtoRefill refillMapperIn, UserService userService) {
        this.refillRepository = refillRepository;
        this.refillMapperIn = refillMapperIn;
        this.userService = userService;
    }

    public List<Refill> findAll() {;
        return this.refillRepository.findAll();
    }

    public Refill createRefill(RefillDTO refillDTO, String userName) {
        Refill refill = refillMapperIn.map(refillDTO);
        refill.setUser(userService.findUserByUserName(userName));
        return this.refillRepository.saveAndFlush(refill);
    }

    public Refill updateRefill(RefillDTO refillDTO, String userName) {
        Refill refill = refillMapperIn.map(refillDTO);
        User creator = userService.findUserByUserName(userName);
        Refill refillInternal = refillRepository.findByiOSidAndUser(refill.getIOSid(), creator);
        refill.setId(refillInternal.getId());
        refill.setUser(creator);
        return this.refillRepository.saveAndFlush(refill);
    }

    public List<Refill> findAllRefillsByUserId(Long id) {
        return this.refillRepository.findAllByUserId(id);
    }
}

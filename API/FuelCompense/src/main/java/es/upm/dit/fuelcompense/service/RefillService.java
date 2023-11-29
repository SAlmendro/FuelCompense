package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.RefillDTOtoRefill;
import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.entity.Refill;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.RefillRepository;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.RefillDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RefillService {

    private RefillRepository refillRepository;
    private RefillDTOtoRefill refillMapperIn;
    private UserService userService;
    private final UserRepository userRepository;

    public RefillService(RefillRepository refillRepository, RefillDTOtoRefill refillMapperIn, UserService userService,
                         UserRepository userRepository) {
        this.refillRepository = refillRepository;
        this.refillMapperIn = refillMapperIn;
        this.userService = userService;
        this.userRepository = userRepository;
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

    public void deleteRefill(String iOSid, String userName) {
        User user = userService.findUserByUserName(userName);
        Refill refill = refillRepository.findByiOSidAndUser(iOSid, user);
        refillRepository.delete(refill);
    }

    public void deleteAllByUserName(String userName) {
        User user = userService.findUserByUserName(userName);
        List<Refill> refills = refillRepository.findAllByUserId(user.getId());
        for(Refill refill : refills) {
            refillRepository.delete(refill);
        }
    }
}

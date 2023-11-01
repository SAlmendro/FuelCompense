package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CompensationRepository extends JpaRepository<Compensation, Long> {

    public List<Compensation> findAllByUserId(Long userId);

    public Compensation findByiOSidAndUser(String iOSid, User user);

}

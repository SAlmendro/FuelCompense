package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.Refill;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RefillRepository extends JpaRepository<Refill, Long> {

    public List<Refill> findAllByUserId(Long id);

}
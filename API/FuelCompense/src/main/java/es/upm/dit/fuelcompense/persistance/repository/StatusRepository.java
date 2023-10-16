package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface StatusRepository extends JpaRepository<Status, Long> {
    
    public List<Status> findAllByCreatorId(Long creatorId);

    @Query("SELECT s FROM Status s LEFT JOIN FETCH s.favorites WHERE s.id = :id")
    Optional<Status> findByIdWithFavorites(@Param("id") Long id);

}

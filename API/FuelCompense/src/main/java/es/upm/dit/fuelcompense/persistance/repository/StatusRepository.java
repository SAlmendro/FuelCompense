package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StatusRepository extends JpaRepository<Status, Long> {
    public Long deleteByIOSidAndCreator_UserName(String iOSid, String userName);

    public List<Status> findAllByCreatorId(Long creatorId);

}

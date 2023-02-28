package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, Long> {



}

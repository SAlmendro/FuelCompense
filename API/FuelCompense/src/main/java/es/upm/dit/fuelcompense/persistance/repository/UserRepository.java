package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;

public interface UserRepository extends JpaRepository<User, Long> {

    public User findUserByUserName(String userName);

}

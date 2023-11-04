package es.upm.dit.fuelcompense.persistance.repository;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface UserRepository extends JpaRepository<User, Long> {

    public User findUserByUserName(String userName);
    public Set<User> findAllByFollowingContains(User user);
    public List<User> findAllByUserNameContainingIgnoreCase(String keyword);
    @Query("SELECT s FROM User s LEFT JOIN FETCH s.favorites WHERE s.id = :id")
    public Optional<User> findByIdWithFavorites(@Param("id") Long id);
}

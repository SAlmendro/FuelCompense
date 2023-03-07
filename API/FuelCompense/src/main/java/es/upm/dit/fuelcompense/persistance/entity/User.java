package es.upm.dit.fuelcompense.persistance.entity;

import lombok.Data;

import javax.persistence.*;
import java.util.*;

@Data
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Column(nullable = false, unique = true)
    private String userName;
    private String refuelings;
    private String compensations;
    @OneToMany(cascade = CascadeType.REMOVE, orphanRemoval = true, fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    @OrderBy("creationDate DESC")
    private List<Status> statuses = new ArrayList<>();
    @ManyToMany(mappedBy = "favorites", fetch = FetchType.EAGER)
    private Set<Status> favoriteStatuses = new LinkedHashSet<>();
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "follows",
            joinColumns = @JoinColumn(name = "follower_id"),
            inverseJoinColumns = @JoinColumn(name = "followed_id"))
    private Set<User> following = new HashSet<User>();

}

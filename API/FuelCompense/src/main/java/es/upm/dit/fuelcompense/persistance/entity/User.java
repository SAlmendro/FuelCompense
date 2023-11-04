package es.upm.dit.fuelcompense.persistance.entity;

import lombok.*;
import org.hibernate.Hibernate;

import javax.persistence.*;
import java.util.*;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @Column(nullable = false, unique = true)
    private String userName;
    @ToString.Exclude
    @OneToMany(mappedBy = "creator", orphanRemoval = true)
    @OrderBy("creationDate")
    private List<Status> statuses = new ArrayList<>();
    @ToString.Exclude
    @ManyToMany(mappedBy = "favorites")
    private Set<Status> favorites = new HashSet<>();
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "follows",
            joinColumns = @JoinColumn(name = "follower_id"),
            inverseJoinColumns = @JoinColumn(name = "followed_id"))
    private Set<User> following = new HashSet<User>();

    @OneToMany(mappedBy = "user", orphanRemoval = true)
    @OrderBy("date ASC")
    @ToString.Exclude
    private List<Refill> refills = new ArrayList<>();
    @OneToMany(mappedBy = "user", orphanRemoval = true)
    @OrderBy("date ASC")
    @ToString.Exclude
    private List<Compensation> compensations = new ArrayList<>();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        User user = (User) o;
        return getId() != null && Objects.equals(getId(), user.getId());
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}

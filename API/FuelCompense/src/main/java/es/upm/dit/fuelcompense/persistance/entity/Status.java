package es.upm.dit.fuelcompense.persistance.entity;

import lombok.*;
import org.hibernate.Hibernate;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "statuses")
public class Status {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private String id;
    @ToString.Exclude
    @ManyToOne(cascade = CascadeType.REMOVE, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User creator;
    private String iOSid;
    private String content;
    private LocalDateTime creationDate;
    @ToString.Exclude
    @ManyToMany
    @JoinTable(name = "favorites",
            joinColumns = @JoinColumn(name = "status_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id"))
    private Set<User> favorites = new HashSet<>();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        Status status = (Status) o;
        return getId() != null && Objects.equals(getId(), status.getId());
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}

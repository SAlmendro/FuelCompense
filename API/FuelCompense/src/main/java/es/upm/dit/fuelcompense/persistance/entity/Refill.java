package es.upm.dit.fuelcompense.persistance.entity;

import lombok.*;
import org.hibernate.Hibernate;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "refills")
public class Refill {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    private String iOSid;
    private Integer odometer;
    private Double liters;
    private Double eurosLiter;
    private Double total;
    private LocalDateTime date;
    private Boolean fullTank;
    private Double totalCarbon;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        Refill refill = (Refill) o;
        return getUser() != null && Objects.equals(getUser(), refill.getUser())
                && getId() != null && Objects.equals(getId(), refill.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, id);
    }
}

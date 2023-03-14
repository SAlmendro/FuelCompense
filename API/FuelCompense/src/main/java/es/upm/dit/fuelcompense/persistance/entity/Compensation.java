package es.upm.dit.fuelcompense.persistance.entity;

import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "compensations")
public class Compensation {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;
    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    private String iOSid;
    private LocalDateTime date;
    private Double tons;
    private String comment;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Compensation that = (Compensation) o;

        if (!id.equals(that.id)) return false;
        if (!user.equals(that.user)) return false;
        if (!iOSid.equals(that.iOSid)) return false;
        if (!date.equals(that.date)) return false;
        if (!tons.equals(that.tons)) return false;
        return Objects.equals(comment, that.comment);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + user.hashCode();
        result = 31 * result + iOSid.hashCode();
        return result;
    }
}

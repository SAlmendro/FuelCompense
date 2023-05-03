package es.upm.dit.fuelcompense.service.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
public class StatusDTO {

    private Long id;
    private String text;
    private Set<String> favs;
    private String authUserName;
    private LocalDateTime creationDate;

}

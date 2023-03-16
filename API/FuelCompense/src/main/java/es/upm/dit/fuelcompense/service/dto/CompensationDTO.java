package es.upm.dit.fuelcompense.service.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
public class CompensationDTO {

    private String id;
    private LocalDateTime date;
    private Double tons;
    private String comment;

}

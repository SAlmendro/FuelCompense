package es.upm.dit.fuelcompense.service.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
public class RefillDTO {

    private String id;
    private Integer odometer;
    private Double liters;
    private Double eurosLiter;
    private Double total;
    private LocalDateTime date;
    private Boolean fullTank;
    private Double totalCarbon;

}
package es.upm.dit.fuelcompense.service.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
public class StatusDTO {

    private String id;
    private String text;
    private String authUserName;

}

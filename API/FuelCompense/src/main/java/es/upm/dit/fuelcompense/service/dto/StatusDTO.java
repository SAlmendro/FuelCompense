package es.upm.dit.fuelcompense.service.dto;

import lombok.Data;

import java.util.List;

@Data
public class StatusDTO {

    private String id;
    private String text;
    private List<String> favs;
    private String authUserName;

}

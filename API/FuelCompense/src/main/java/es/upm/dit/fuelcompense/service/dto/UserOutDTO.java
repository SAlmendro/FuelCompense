package es.upm.dit.fuelcompense.service.dto;

import lombok.Data;

import java.util.List;

@Data
public class UserOutDTO {

    private Long id;
    private String userName;
    private List<StatusOutDTO> statuses;
    private List<String> usersFollowing;

}

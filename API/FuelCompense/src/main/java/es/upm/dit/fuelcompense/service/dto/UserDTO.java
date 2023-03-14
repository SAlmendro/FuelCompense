package es.upm.dit.fuelcompense.service.dto;

import lombok.Data;

import java.util.List;

@Data
public class UserDTO {

    private Long id;
    private String userName;
    private List<StatusDTO> statuses;
    private List<String> usersFollowing;

}

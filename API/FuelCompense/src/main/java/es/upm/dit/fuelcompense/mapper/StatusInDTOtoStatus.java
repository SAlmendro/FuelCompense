package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.StatusInDTO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class StatusInDTOtoStatus implements IMapper<StatusInDTO, Status> {

    private final UserService userService;

    public StatusInDTOtoStatus(UserService userService) {
        this.userService = userService;
    }

    @Override
    public Status map(StatusInDTO in){
        Status status = new Status();
        status.setContent(in.getContent());
        status.setCreator(userService.findUserByUserName(in.getUserName()));
        status.setCreationDate(LocalDateTime.now());
        status.setId(in.getId());
        return status;
    }

}

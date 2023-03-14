package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class StatusDTOtoStatus implements IMapper<StatusDTO, Status> {

    private final UserService userService;

    public StatusDTOtoStatus(UserService userService) {
        this.userService = userService;
    }

    @Override
    public Status map(StatusDTO in){
        Status status = new Status();
        status.setIOSid(in.getId());
        status.setContent(in.getText());
        status.setCreator(userService.findUserByUserName(in.getAuthUserName()));
        status.setCreationDate(LocalDateTime.now());
        return status;
    }

}

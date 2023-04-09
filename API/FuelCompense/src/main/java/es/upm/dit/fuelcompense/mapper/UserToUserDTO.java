package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class UserToUserDTO implements IMapper<User, UserDTO> {

    private final StatusService statusService;
    private final StatusToStatusDTO statusMapperOut;

    public UserToUserDTO(StatusService statusService, StatusToStatusDTO statusMapperOut) {
        this.statusService = statusService;
        this.statusMapperOut = statusMapperOut;
    }

    @Override
    public UserDTO map(User in){
        UserDTO userOut = new UserDTO();
        userOut.setUserName(in.getUserName());
        return userOut;
    }

    public List<UserDTO> listMap(List<User> in) {
        List<UserDTO> out = new ArrayList<UserDTO>();
        for (User u : in ) {
            out.add(map(u));
        }
        return out;
    }

}

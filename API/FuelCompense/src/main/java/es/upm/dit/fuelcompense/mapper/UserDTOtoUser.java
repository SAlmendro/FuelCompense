package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.stereotype.Component;

@Component
public class UserDTOtoUser implements IMapper<UserDTO, User> {

    @Override
    public User map(UserDTO in){
        User user = new User();
        user.setUserName(in.getUserName());
        return user;
    }

}

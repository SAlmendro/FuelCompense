package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.UserInDTO;
import org.springframework.stereotype.Component;

@Component
public class UserInDTOtoUser implements IMapper<UserInDTO, User> {

    @Override
    public User map(UserInDTO in){
        User user = new User();
        user.setUserName(in.getUserName());
        return user;
    }

}

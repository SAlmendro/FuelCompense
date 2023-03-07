package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.dto.UserOutDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class UserToUserOutDTO implements IMapper<User, UserOutDTO> {

    private final StatusService statusService;
    private final StatusToStatusOutDTO statusMapperOut;

    public UserToUserOutDTO(StatusService statusService, StatusToStatusOutDTO statusMapperOut) {
        this.statusService = statusService;
        this.statusMapperOut = statusMapperOut;
    }

    @Override
    public UserOutDTO map(User in){
        UserOutDTO userOut = new UserOutDTO();
        userOut.setUserName(in.getUserName());
        userOut.setId(in.getId());
        List<String> following = new ArrayList<String>();
        for (User u : in.getFollowing()) {
            following.add(u.getUserName());
        }
        userOut.setUsersFollowing(following);
        List<Status> statuses = statusService.findAllStatusesByCreatorId(in.getId());
        userOut.setStatuses(statusMapperOut.listMap(statuses));
        return userOut;
    }

    public List<UserOutDTO> listMap(List<User> in) {
        List<UserOutDTO> out = new ArrayList<UserOutDTO>();
        for (User u : in ) {
            out.add(map(u));
        }
        return out;
    }

}

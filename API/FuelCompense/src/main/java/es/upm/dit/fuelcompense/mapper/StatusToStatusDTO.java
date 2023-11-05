package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
public class StatusToStatusDTO implements IMapper<Status, StatusDTO> {

    @Override
    public StatusDTO map(Status in) {
        StatusDTO out = new StatusDTO();
        out.setId(in.getId());
        out.setText(in.getContent());
        out.setAuthUserName(in.getCreator().getUserName());
        out.setIOSid(in.getIOSid());
        Set<String> favs = new HashSet<String>();
        for (User u : in.getFavorites()) {
            favs.add(u.getUserName());
        }
        out.setFavs(favs);
        out.setCreationDate(in.getCreationDate());
        return out;
    }

    public List<StatusDTO> listMap(List<Status> in) {
        List<StatusDTO> out = new ArrayList<StatusDTO>();
        for (Status s : in ) {
            out.add(map(s));
        }
        return out;
    }

}

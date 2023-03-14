package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.service.dto.StatusOutDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class StatusToStatusOutDTO implements IMapper<Status, StatusOutDTO> {

    @Override
    public StatusOutDTO map(Status in) {
        StatusOutDTO out = new StatusOutDTO();
        out.setId(in.getId());
        out.setContent(in.getContent());
        out.setCreatorUserName(in.getCreator().getUserName());
        return out;
    }

    public List<StatusOutDTO> listMap(List<Status> in) {
        List<StatusOutDTO> out = new ArrayList<StatusOutDTO>();
        for (Status s : in ) {
            out.add(map(s));
        }
        return out;
    }

}

package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CompensationDTOtoCompensation implements IMapper<CompensationDTO, Compensation> {

    @Override
    public Compensation map(CompensationDTO in) {
        Compensation out = new Compensation();
        out.setIOSid(in.getId());
        out.setDate(in.getDate());
        out.setTons(in.getTons());
        out.setComment(in.getComment());
        return out;
    }

    public List<Compensation> listMap(List<CompensationDTO> in, User user) {
        List<Compensation> out = new ArrayList<Compensation>();
        for (CompensationDTO c : in) {
            Compensation compensation = map(c);
            compensation.setUser(user);
            out.add(compensation);
        }
        return out;
    }

}

package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CompensationtoCompensationDTO implements IMapper<Compensation, CompensationDTO> {

    @Override
    public CompensationDTO map(Compensation in) {
        CompensationDTO out = new CompensationDTO();
        out.setId(in.getIOSid());
        out.setDate(in.getDate());
        out.setTons(in.getTons());
        out.setComment(in.getComment());
        return out;
    }

    public List<CompensationDTO> listMap(List<Compensation> in) {
        List<CompensationDTO> out = new ArrayList<CompensationDTO>();
        for (Compensation compensation : in) {
            out.add(map(compensation));
        }
        return out;
    }
}

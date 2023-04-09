package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Refill;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.RefillDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class RefilltoRefillDTO implements IMapper<Refill, RefillDTO> {

    @Override
    public RefillDTO map(Refill in) {
        RefillDTO out = new RefillDTO();
        out.setId(in.getIOSid());
        out.setOdometer(in.getOdometer());
        out.setLiters(in.getLiters());
        out.setEurosLiter(in.getEurosLiter());
        out.setTotal(in.getTotal());
        out.setDate(in.getDate());
        out.setFullTank(in.getFullTank());
        out.setTotalCarbon(in.getTotalCarbon());
        return out;
    }

    public List<RefillDTO> listMap(List<Refill> in) {
        List<RefillDTO> out = new ArrayList<RefillDTO>();
        for (Refill r: in) {
            out.add(map(r));
        }
        return out;
    }

}

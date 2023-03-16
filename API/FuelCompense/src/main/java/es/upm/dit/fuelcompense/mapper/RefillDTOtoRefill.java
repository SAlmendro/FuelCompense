package es.upm.dit.fuelcompense.mapper;

import es.upm.dit.fuelcompense.persistance.entity.Refill;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.dto.RefillDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class RefillDTOtoRefill implements IMapper<RefillDTO, Refill> {

    @Override
    public Refill map(RefillDTO in) {
        Refill out = new Refill();
        out.setIOSid(in.getId());
        out.setOdometer(in.getOdometer());
        out.setLiters(in.getLiters());
        out.setEurosLiter(in.getEurosLiter());
        out.setTotal(in.getTotal());
        out.setDate(in.getDate());
        out.setFullTank(in.getFullTank());
        out.setTotalCarbon(in.getTotalCarbon());
        return out;
    }

    public List<Refill> listMap(List<RefillDTO> in, User user) {
        List<Refill> out = new ArrayList<Refill>();
        for (RefillDTO r: in) {
            Refill refill = map(r);
            refill.setUser(user);
            out.add(refill);
        }
        return out;
    }

}

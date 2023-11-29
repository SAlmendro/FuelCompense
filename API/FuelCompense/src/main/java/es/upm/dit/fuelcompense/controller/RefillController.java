package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.RefilltoRefillDTO;
import es.upm.dit.fuelcompense.persistance.entity.Refill;
import es.upm.dit.fuelcompense.service.RefillService;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import es.upm.dit.fuelcompense.service.dto.RefillDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@RestController
@RequestMapping("/refills")
public class RefillController {

    private final RefillService refillService;
    private final RefilltoRefillDTO refillMapperOut;
    private final UserService userService;

    public RefillController(RefillService refillService, RefilltoRefillDTO refillMapperOut, UserService userService) {
        this.refillService = refillService;
        this.refillMapperOut = refillMapperOut;
        this.userService = userService;
    }

    @PostMapping(value = "/{userName}")
    public RefillDTO createRefill(@PathVariable String userName, @RequestBody RefillDTO refillDTO) {
        Logger.getAnonymousLogger().log(Level.WARNING, userName + " ha solicitado crear un refill.");
        Refill refill = this.refillService.createRefill(refillDTO, userName);
        return refillMapperOut.map(refill);
    }

    @PutMapping(value = "/{userName}")
    public RefillDTO updateRefill(@PathVariable String userName, @RequestBody RefillDTO refillDTO) {
        Logger.getAnonymousLogger().log(Level.WARNING, userName + " ha solicitado modificar el refill: " + refillDTO.getId());
        Refill refill = this.refillService.updateRefill(refillDTO, userName);
        return refillMapperOut.map(refill);
    }

    @GetMapping(value = "/{userName}")
    public List<RefillDTO> findAllByUserName(@PathVariable("userName") String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han solicitado todos los refills de: " + userName);
        return refillMapperOut.listMap(this.refillService.findAllRefillsByUserId(this.userService.findUserByUserName(userName).getId()));
    }

    @DeleteMapping(value = "/{iOSid}")
    public void delete(@PathVariable("iOSid") String iOSid, @RequestBody String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, userName + " ha solicitado borrar el refill con id: " + iOSid);
        refillService.deleteRefill(iOSid, userName);
    }

    @DeleteMapping(value = "/deleteAll/{userName}")
    public void deleteAll(@PathVariable("userName") String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, userName + " ha solicitado borrar todos sus refills.");
        refillService.deleteAllByUserName(userName);
    }
}

package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@RestController
@RequestMapping("/statuses")
public class StatusController {

    private final StatusService statusService;
    private final UserService userService;
    private final StatusToStatusDTO statusMapperOut;

    public StatusController(StatusService statusService, UserService userService, StatusToStatusDTO statusMapperOut) {
        this.statusService = statusService;
        this.userService = userService;
        this.statusMapperOut = statusMapperOut;
    }

    @PostMapping(value = "/new")
    public StatusDTO createStatus(@RequestBody StatusDTO statusDTO) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se esta intentando crear un estado. Usuario " + statusDTO.getAuthUserName());
        return this.statusMapperOut.map(this.statusService.createStatus(statusDTO));
    }

    @GetMapping
    public List<StatusDTO> findAll() {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han buscado todos los estados");
        return this.statusMapperOut.listMap(this.statusService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public List<StatusDTO> findAllByUserName(@PathVariable("userName") String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han buscado todos los estados de " + userName);
        return this.statusMapperOut.listMap(this.statusService.findAllStatusesByCreatorId(this.userService.findUserByUserName(userName).getId()));
    }

    @GetMapping(value = "/subscribed/{userName}")
    public List<StatusDTO> findAllBySubscriberUserName(@PathVariable("userName") String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han buscado todos los estados a los que esta suscrito " + userName);
        return this.statusMapperOut.listMap(this.statusService.findAllStatusesBySubscriberUserName(userName));
    }

    @DeleteMapping(value = "/{id}")
    public Boolean deleteStatus(@PathVariable("id") Long id) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se intenta borrar el estado " + id);
        try {
            this.statusService.deleteStatus(id);
            return true;
        } catch (Exception e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, "Ha habido un error borrando el estado. Traza: " + e.getMessage());
            return false;
        }
    }

    @PostMapping(value = "/fav/{statusId}")
    public Boolean updateFav(@PathVariable("statusId") Long statusId, @RequestBody String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han buscado todos los estados favs de " + userName);
        return this.statusService.changeFavorite(statusId, userName).get();
    }

}

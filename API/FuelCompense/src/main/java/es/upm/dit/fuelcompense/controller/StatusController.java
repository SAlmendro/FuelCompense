package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
        return this.statusMapperOut.map(this.statusService.createStatus(statusDTO));
    }

    @GetMapping
    public List<StatusDTO> findAll() {
        return this.statusMapperOut.listMap(this.statusService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public List<StatusDTO> findAllByUserName(@PathVariable("userName") String userName) {
        return this.statusMapperOut.listMap(this.statusService.findAllStatusesByCreatorId(this.userService.findUserByUserName(userName).getId()));
    }

    @GetMapping(value = "/subscribed/{userName}")
    public List<StatusDTO> findAllBySubscriberUserName(@PathVariable("userName") String userName) {
        return this.statusMapperOut.listMap(this.statusService.findAllStatusesBySubscriberUserName(userName));
    }

    @DeleteMapping(value = "/{id}")
    public Boolean deleteStatus(@PathVariable("id") Long id) {
        try {
            this.statusService.deleteStatus(id);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @PostMapping(value = "/fav/{statusId}")
    public Boolean updateFav(@PathVariable("statusId") Long statusId, @RequestBody String userName) {
        return this.statusService.changeFavorite(statusId, userName).get();
    }

}

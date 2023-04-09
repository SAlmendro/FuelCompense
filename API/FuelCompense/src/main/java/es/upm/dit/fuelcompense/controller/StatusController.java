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
        return statusMapperOut.map(this.statusService.createStatus(statusDTO));
    }

    @GetMapping
    public List<StatusDTO> findAll() {
        return statusMapperOut.listMap(this.statusService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public List<StatusDTO> findAllByUserName(@PathVariable("userName") String userName) {
        return statusMapperOut.listMap(this.statusService.findAllStatusesByCreatorId(this.userService.findUserByUserName(userName).getId()));
    }

    @GetMapping(value = "/subscribed/{userName}")
    public List<StatusDTO> findAllBySubscriberUserName(@PathVariable("userName") String userName) {
        return statusMapperOut.listMap(this.statusService.findAllStatusesBySubscriberUserName(userName));
    }

}

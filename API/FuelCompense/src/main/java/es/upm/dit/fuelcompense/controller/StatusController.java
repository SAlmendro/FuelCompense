package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.StatusToStatusDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.dto.StatusDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/statuses")
public class StatusController {

    private final StatusService statusService;
    private final StatusToStatusDTO statusMapperOut;

    public StatusController(StatusService statusService, StatusToStatusDTO statusMapperOut) {
        this.statusService = statusService;
        this.statusMapperOut = statusMapperOut;
    }

    @PostMapping
    public Status createStatus(@RequestBody StatusDTO statusDTO) {
        return this.statusService.createStatus(statusDTO);
    }

    @GetMapping
    public List<StatusDTO> findAll() {
        return statusMapperOut.listMap(this.statusService.findAll());
    }

/*    @GetMapping
    public List<StatusOutDTO> findAllFollowingStatuses(@RequestBody String userName) {
        return statusMapperOut.listMap(this.statusService.findAllFollowingStatuses(userName));
    }*/

}

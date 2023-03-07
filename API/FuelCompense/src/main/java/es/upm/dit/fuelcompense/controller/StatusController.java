package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.StatusToStatusOutDTO;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.service.StatusService;
import es.upm.dit.fuelcompense.service.dto.StatusInDTO;
import es.upm.dit.fuelcompense.service.dto.StatusOutDTO;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/statuses")
public class StatusController {

    private final StatusService statusService;
    private final StatusToStatusOutDTO statusMapperOut;

    public StatusController(StatusService statusService, StatusToStatusOutDTO statusMapperOut) {
        this.statusService = statusService;
        this.statusMapperOut = statusMapperOut;
    }

    @PostMapping
    public Status createStatus(@RequestBody StatusInDTO statusInDTO) {
        return this.statusService.createStatus(statusInDTO);
    }

    @GetMapping
    public List<StatusOutDTO> findAll() {
        return statusMapperOut.listMap(this.statusService.findAll());
    }

/*    @GetMapping
    public List<StatusOutDTO> findAllFollowingStatuses(@RequestBody String userName) {
        return statusMapperOut.listMap(this.statusService.findAllFollowingStatuses(userName));
    }*/

}

package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.CompensationToCompensationDTO;
import es.upm.dit.fuelcompense.persistance.entity.Compensation;
import es.upm.dit.fuelcompense.service.CompensationService;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.CompensationDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/compensations")
public class CompensationController {

    private final CompensationService compensationService;
    private final UserService userService;
    private final CompensationToCompensationDTO compensationMapperOut;

    public CompensationController(CompensationService compensationService, UserService userService, CompensationToCompensationDTO compensationMapperOut) {
        this.compensationService = compensationService;
        this.userService = userService;
        this.compensationMapperOut = compensationMapperOut;
    }

    @PostMapping(value = "/{userName}")
    public CompensationDTO createCompensation(@PathVariable String userName, @RequestBody CompensationDTO compensationDTO) {
        Compensation compensation = this.compensationService.createCompensation(compensationDTO, userName);
        return compensationMapperOut.map(compensation);
    }

    @GetMapping
    public List<CompensationDTO> findAll() {
        return compensationMapperOut.listMap(this.compensationService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public List<CompensationDTO> findAllByUserName(@PathVariable("userName") String userName) {
        return compensationMapperOut.listMap(this.compensationService.findAllCompensationsByUserId(this.userService.findUserByUserName(userName).getId()));
    }

    @PutMapping(value = "/{userName}")
    public CompensationDTO updateCompensation(@PathVariable String userName, @RequestBody CompensationDTO compensationDTO) {
        Compensation compensation = this.compensationService.updateCompensation(compensationDTO, userName);
        return compensationMapperOut.map(compensation);
    }

    @DeleteMapping(value = "/{iOSid}")
    public void delete(@PathVariable("iOSid") String iOSid, @RequestBody String userName) {
        compensationService.deleteCompensation(iOSid, userName);
    }

}

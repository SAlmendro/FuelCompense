package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.UserInDTOtoUser;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.UserInDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository repository;
    private final UserInDTOtoUser mapper;

    public UserService(UserRepository repository, UserInDTOtoUser mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    public User createUser(UserInDTO userInDTO) {
        User user = mapper.map(userInDTO);
        return this.repository.save(user);
    }

    public List<User> findAll() {
        return this.repository.findAll();
    }

}
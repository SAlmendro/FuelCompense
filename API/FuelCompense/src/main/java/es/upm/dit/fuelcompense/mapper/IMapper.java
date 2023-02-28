package es.upm.dit.fuelcompense.mapper;

public interface IMapper<I, O> {
    public O map(I in);
}

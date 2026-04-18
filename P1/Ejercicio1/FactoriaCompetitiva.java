public class FactoriaCompetitiva implements FactoriaPartidaYJugador {
    @Override
    public Jugador crearJugador(int id) {
        return new JugadorCompetitivo(id);
    }

    @Override
    public Partida crearPartida(int numero_jugadores) {
        return new PartidaCompetitiva(numero_jugadores);
    }
}
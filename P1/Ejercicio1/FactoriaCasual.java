public class FactoriaCasual implements FactoriaPartidaYJugador {
    @Override
    public Jugador crearJugador(int id) {
        return new JugadorCasual(id);
    }

    @Override
    public Partida crearPartida(int numero_jugadores) {
        return new PartidaCasual(numero_jugadores);
    }
}
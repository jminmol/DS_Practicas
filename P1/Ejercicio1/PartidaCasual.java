import java.util.ArrayList;

public class PartidaCasual extends Partida {
    public PartidaCasual(int numero_jugadores) {
        jugadores = new ArrayList<>(numero_jugadores);
        this.numero_jugadores = numero_jugadores;
        porcentaje_abandono = 10;
        nombreModalidad = "CASUAL";
    }
}
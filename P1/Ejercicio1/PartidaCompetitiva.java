import java.util.ArrayList;

public class PartidaCompetitiva extends Partida {
    public PartidaCompetitiva(int numero_jugadores) {
        jugadores = new ArrayList<>(numero_jugadores);
        this.numero_jugadores = numero_jugadores;
        porcentaje_abandono = 20;
        nombreModalidad = "COMPETITIVA";
    }
}
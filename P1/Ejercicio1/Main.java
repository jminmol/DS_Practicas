import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println("Introduce el número de jugadores para las partidas:");
        Scanner scanner = new Scanner(System.in);
        int numJugadores = scanner.nextInt();

        FactoriaPartidaYJugador factoriaCasual = new FactoriaCasual();
        FactoriaPartidaYJugador factoriaCompetitiva = new FactoriaCompetitiva();

        Partida partidaCasual = factoriaCasual.crearPartida(numJugadores);
        Partida partidaCompetitiva = factoriaCompetitiva.crearPartida(numJugadores);

        for (int i = 1; i <= numJugadores; i++) {
            partidaCasual.jugadores.add(factoriaCasual.crearJugador(i));
            partidaCompetitiva.jugadores.add(factoriaCompetitiva.crearJugador(i));
        }

        System.out.println("Partida Casual - Porcentaje de abandono: " + partidaCasual.porcentaje_abandono + "%");
        System.out.println("Partida Competitiva - Porcentaje de abandono: " + partidaCompetitiva.porcentaje_abandono + "%");
        System.out.println("Número de jugadores en ambas partidas: " + numJugadores + "\n");

        Thread hiloCasual = new Thread(partidaCasual);
        Thread hiloCompetitiva = new Thread(partidaCompetitiva);

        hiloCasual.start();
        hiloCompetitiva.start();

        try {
            hiloCasual.join();
            hiloCompetitiva.join();
        } catch (InterruptedException e) {
            System.out.println("El programa principal fue interrumpido.");
        }

    }   
}
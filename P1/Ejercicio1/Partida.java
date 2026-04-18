import java.util.ArrayList;
import java.util.Random;

public abstract class Partida implements Runnable {
    int numero_jugadores;
    ArrayList<Jugador> jugadores;
    int porcentaje_abandono;
    String nombreModalidad;
    int Tiempo_Partida = 60000;

    @Override
    public void run() {
        System.out.println("Comenzando partida " + nombreModalidad + "\n");

        int jugadoresAbandonan = numero_jugadores * porcentaje_abandono / 100;

        Random random = new Random();
        int tiempoAbandono = random.nextInt((int)(2.0/3*Tiempo_Partida)) + (int)(1.0/6*Tiempo_Partida); 

        try {
            Thread.sleep(tiempoAbandono); 
        } catch (InterruptedException e) {
            System.out.println("La partida " + nombreModalidad + " fue interrumpida.");
        }

        System.out.println("Jugadores que abandonaron la partida " + nombreModalidad + ": " + jugadoresAbandonan);
        for (int i = 0; i < jugadoresAbandonan && !jugadores.isEmpty(); i++) {
            int jugadorAEliminar = random.nextInt(jugadores.size());
            System.out.println("Jugador " + jugadores.get(jugadorAEliminar).id + " ha abandonado la partida " + nombreModalidad);
            jugadores.remove(jugadorAEliminar);
        }
        System.out.println("\n");

        try {
            Thread.sleep(Tiempo_Partida - tiempoAbandono); 
        } catch (InterruptedException e) {
            System.out.println("La partida " + nombreModalidad + " fue interrumpida.");
        }

        System.out.println("Finalizando partida " + nombreModalidad);
    }
}

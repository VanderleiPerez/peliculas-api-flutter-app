import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class CardSwiper extends StatelessWidget {
  // PARA PROVIDER
  final List<Movie> movies;
  // Como se creó la variable movies, se habilita el constructor del mismo
  const CardSwiper({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Permite obtener información sobre el dispositivo (como alto ,ancho)
    final size = MediaQuery.of(context).size;
    // Condicional inicial para no mandar error, porque al inicio la lista está vacio
    if (this.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity, //Tomar todo el ancho
      height: size.height * 0.5,
      //color: Colors.indigo,
      // ANIMACIÓN DE TARJETAS - LIBRERÍA card_swiper 1.0.4

      child: Swiper(
          itemCount: movies.length, // tamaño de MOVIE json
          layout: SwiperLayout.STACK,
          itemHeight: size.height * 0.4,
          itemWidth: size.width * 0.6,
          itemBuilder: (_, int index) {
            // Poner imagenes
            final movie = movies[index];
            //print(movie.fullPosterImg);
            // GestureDetector: cuando se haga onTag a la imagen llevará a otra pantalla

            movie.heroId = 'swiper-${movie.id}';

            return GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                // ClipRRect: Darle borde a la imagen
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // Animación de entrada antes de cargas
                    child: FadeInImage(
                        placeholder: AssetImage('assets/no-image.jpg'),
                        image: NetworkImage(movie.fullPosterImg),
                        fit: BoxFit.cover)),
              ),
            );
          }),
    );
  }
}

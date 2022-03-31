// Hacer lo más reutilizable este widget
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  // PARA PROVIDER
  final List<Movie> movies;
  final String? title;
  // Variable para el initState (FINAL)
  final Function onNextPage;

  const MovieSlider(
      {Key? key,
      required this.movies,
      required this.title,
      required this.onNextPage})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = new ScrollController();
  // Se ejecuta código la primera vez que es construido
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Bloqueo para reducir el número de peticiones (cuando esté cerca "-500")
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
        // Se asocia al ListView
      }
    });
  }

  // Se ejecuta código cuando va a ser destruido
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Condicional inicial para no mandar error, porque al inicio la lista está vacio
    if (this.widget.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: 250,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 250,
      //color: Colors.green,
      child: Column(
        //Posición de texto 'Populares'
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.widget.title != null)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(this.widget.title!,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

          // ListView builder define su ancho basado en su padre COLUM
          // Se debe envolver ListView.builder en un expander
          Expanded(
            child: ListView.builder(
              //Scroll creado al inicio del stafull
              controller: scrollController,
              // Manejar dirección del scroll HORIZONTAL

              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) {
                return _MoviePoster(
                    movie: widget.movies[index],
                    heroId:
                        '${widget.title}-$index-${widget.movies[index].id}');
              },
            ),
          )
        ],
      ),
    );
  }
}

// Como va a ser prinvado se le coloca _ , porque no se usará en otro lugar
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;
  const _MoviePoster({required this.movie, required this.heroId});

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 170,
      //color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          //Permite usar OnTap para navegar entre pantallas
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
            child: Hero(
              tag: movie.id,
              // SE ENVUELVE: Widget para agregar borde y HERO
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                //SE ENVUELVE
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Usar WIDGET flexible en text
          Flexible(
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

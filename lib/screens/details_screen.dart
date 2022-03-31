import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: Luego cambiar por una instancia de movie
    final Movie movies = ModalRoute.of(context)!.settings.arguments
        as Movie; // SE CAMBIÓ para trabajar con Json
    print(movies.title);

    return Scaffold(
      //appBar: AppBar(),
      body: CustomScrollView(
        // Se debe color WIDGET de la familia Slivers
        slivers: [
          _customAppBar(movie: movies),
          SliverList(
              delegate: SliverChildListDelegate([
            _PosterAndTitle(movie: movies),
            _Overview(movie: movies),
            CastingCard(movieId: movies.id)
          ]))
        ],
      ),
    );
  }
}

// CLASE PARA APPBAR
class _customAppBar extends StatelessWidget {
  final Movie movie;

  const _customAppBar({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parecido al AppBar, pero con SCROLL
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200, // Alto del appBar
      floating: false,
      pinned: true, //No desaparecer AppBar
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Eliminar padding en el AppBar
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12, // Darle transparencia oscuro a la imagen
          child: Text(
            movie.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackDropPath),
          fit: BoxFit.cover, // Expandir imagen sin perder forma
        ),
      ),
    );
  }
}

// CLASE PARA CREAR POSTER Y TITULO
class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Evitar hacerlo repetitivo el Theme (para los Rows)
    final TextTheme texTheme = Theme.of(context).textTheme;
    //  Obtener tamaño de pantalla
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),

      // Colocal elementos uno al lado del otro
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                // Solucionar diferencia de tamaños
                height: 150,
              ),
            ),
          ),
          // DAR SEPARACIÓN
          SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              // Alinear en un mismo inicio las columnas
              crossAxisAlignment: CrossAxisAlignment.start,
              // Personalizar
              children: [
                Text(
                  movie.title,
                  style: texTheme.headline5,
                  // Si se tiene un texto largo que se muestre
                  overflow: TextOverflow.ellipsis,
                  //Que se muestrte en 2 lineas
                  maxLines: 4,
                ),
                Text(
                  movie.originalTitle,
                  style: texTheme.subtitle1,
                  // Si se tiene un texto largo que se muestre
                  overflow: TextOverflow.ellipsis,
                  //Que se muestrte en 2 lineas
                  maxLines: 2,
                ),
                // Estrellas
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    // Separar
                    SizedBox(width: 12),
                    Text(
                      movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

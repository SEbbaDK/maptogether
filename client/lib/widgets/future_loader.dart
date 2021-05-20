import 'package:flutter/material.dart';

import 'package:client/widgets/error.dart';
import 'package:client/widgets/loading.dart';

class FutureLoader<F> extends StatelessWidget {

	Future<F> future;
	Widget Function(BuildContext, F) builder;

	FutureLoader({ @required this.future, @required this.builder });
    
	@override
	build(BuildContext context) =>
		FutureBuilder(
    		future: future,
    		builder: (BuildContext context, AsyncSnapshot<F> snapshot) =>
    			snapshot.hasData
    				? builder(context, snapshot.data)
    				: snapshot.hasError
    					? Error(snapshot.error)
    					: Loading()
		);
}

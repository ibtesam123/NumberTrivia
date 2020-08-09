import 'package:dartz/dartz.dart' as dartz;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/error/failure.dart';
import '../../core/validators.dart';
import '../../domain/model/Number.dart';
import '../../providers/NumbersProvider.dart';
import '../widgets/appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FocusNode focusNode;
  GlobalKey<FormState> key;
  NumbersProvider staticProvider;
  int number;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(canRequestFocus: true);
    key = GlobalKey<FormState>();
    staticProvider = Provider.of<NumbersProvider>(context, listen: false);
  }

  Widget _buildNumberText(dartz.Either<Failure, Number> numberTrivia) {
    return numberTrivia.fold(
      (l) => Text(l.message),
      (r) => Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              r.number.toString(),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 4,
            child: Text(
              r.text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNumberTextOrLoading() {
    return Consumer<NumbersProvider>(
      builder: (context, provider, widget) {
        return provider.isLoading
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(10),
                child: _buildNumberText(provider.numberTrivia),
              );
      },
    );
  }

  Widget _buildTextArea() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: _buildNumberTextOrLoading(),
      ),
    );
  }

  Widget _buildNumberInput() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Form(
        key: key,
        child: TextFormField(
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 5.0),
            ),
            hintText: 'Enter your favourite number.',
          ),
          style: TextStyle(color: Colors.black87),
          validator: isValidNumber,
          keyboardType: TextInputType.number,
          onSaved: (s) {
            number = int.tryParse(s);
          },
        ),
      ),
    );
  }

  Widget _buildSingleNumberButton() {
    return Expanded(
      flex: 10,
      child: FlatButton(
        onPressed: () {
          focusNode.unfocus();
          if (!key.currentState.validate()) return;

          key.currentState.save();

          staticProvider.getSingleNumber(number: number);
        },
        color: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildRandomNumberButton() {
    return Expanded(
      flex: 10,
      child: FlatButton(
        onPressed: () {
          focusNode.unfocus();
          staticProvider.getRandomNumber();
        },
        color: Colors.grey,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Random Number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        children: <Widget>[
          _buildSingleNumberButton(),
          Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          _buildRandomNumberButton(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            _buildTextArea(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _buildNumberInput(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildBody(),
    );
  }
}

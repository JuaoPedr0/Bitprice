import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import "dart:async";
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, String> moedas = {
    'ARS': 'Peso Argentino',
    'CZK': 'Coroa Checa',
    'HRK': 'Kuna Croata',
    'HUF': 'Florim Húngaro',
    'RON': 'Leu Romeno',
    'TRY': 'Lira Turca',
    'TWD': 'Novo Dólar de Taiwan',
    'USD': 'Dólar Americano',
    'AUD': 'Dólar Australiano',
    'BRL': 'Real Brasileiro',
    'CAD': 'Dólar Canadense',
    'CHF': 'Franco Suíço',
    'CLP': 'Peso Chileno',
    'CNY': 'Yuan Chinês',
    'DKK': 'Coroa Dinamarquesa',
    'EUR': 'Euro',
    'GBP': 'Libra Esterlina',
    'HKD': 'Dólar de Hong Kong',
    'INR': 'Rupia Indiana',
    'ISK': 'Coroa Islandesa',
    'JPY': 'Iene Japonês',
    'KRW': 'Won Sul-Coreano',
    'NZD': 'Dólar Neozelandês',
    'PLN': 'Zloty Polonês',
    'RUB': 'Rublo Russo',
    'SEK': 'Coroa Sueca',
    'SGD': 'Dólar de Singapura',
    'THB': 'Baht Tailandês',
  };
  late Timer timer;
  late int selectedindex = 0;
  late Map retorno;
  List<dynamic> valores = [];
  String _preco = '0';
  String _symbol = 'USD';
  String _ultimaAtualizacao = '';
  final DateFormat formatoDataHora = DateFormat('dd/MM/yy HH:mm:ss');



  void _recuperarPreco() async {
    final dio = Dio();
    final response = await dio.get('https://blockchain.info/ticker');
    final retorno = response.data;
    setState(() {
      this.retorno = retorno;
      valores = retorno.values.toList();
      _preco = retorno[_symbol]['buy'].toString();
      _ultimaAtualizacao = 'Última atualização: ${formatoDataHora.format(DateTime.now())}';

    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset.zero,
                blurRadius: 15,
                blurStyle: BlurStyle.outer
              ),
            ]
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: retorno.length,
            itemBuilder: (BuildContext context, int index) {
              String key = retorno.keys.elementAt(index);
              return Column(
                children: [
                  ListTile(
                    selected: selectedindex == index,
                    trailing: selectedindex == index ? const Icon(Icons.check, color: Colors.black,) : null,
                    title: Text(key, style: const TextStyle(color: Colors.black),),
                    subtitle: Text(moedas[key] ?? '',  style: const TextStyle(color: Colors.black38),),
                    onTap: () {
                      setState(() {
                        selectedindex = index;
                        _symbol = key;
                      });
                      _recuperarPreco();
                      Navigator.pop(context);
                    },
                  ),

                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _recuperarPreco();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _recuperarPreco());
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text("Preço Bitcoin",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  [
               Column(
                 children: [
                   Image.asset('assets/bitcoin.png'),
                   Padding(
                     padding: const EdgeInsets.only(top: 30, bottom: 30),
                     child: Text(
                       "$_symbol: $_preco",
                       style: const TextStyle(fontSize: 35),
                     ),
                   ),
                   Text(
                     _ultimaAtualizacao,
                     style: const TextStyle(fontSize: 18, color: Colors.black),
                   ),
                 ],
               ),
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.only(bottom: 36),
                child: InkWell(
                  onTap: _showBottomSheet,
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.add),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}





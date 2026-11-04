import 'package:flutter/material.dart';

void main() {
  runApp(const QcmApp());
}

class QcmApp extends StatelessWidget {
  const QcmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prépa Technicien 1er Grade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const QcmHomePage(),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class QcmHomePage extends StatefulWidget {
  const QcmHomePage({super.key});

  @override
  State<QcmHomePage> createState() => _QcmHomePageState();
}

class _QcmHomePageState extends State<QcmHomePage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;

  final List<Question> _questions = [
    Question(
      questionText: "Quelle est la superficie officielle globale du Maroc ?",
      options: ["710 850 km²", "446 550 km²", "510 850 km²", "610 850 km²"],
      correctAnswerIndex: 0,
      explanation:
          "Superficie totale incluant l'ensemble des provinces du territoire national.",
    ),
    Question(
      questionText: "Quel est le point culminant du Haut Atlas et du Maroc ?",
      options: [
        "Djebel M'Goun",
        "Djebel Toubkal",
        "Djebel Ayachi",
        "Djebel Siroua"
      ],
      correctAnswerIndex: 1,
      explanation: "Le djebel Toubkal culmine à 4 167 mètres d'altitude.",
    ),
    Question(
      questionText: "Quel est le fleuve le plus long du Maroc ?",
      options: ["Oum Errabiâ", "Sebou", "Drâa", "Moulouya"],
      correctAnswerIndex: 2,
      explanation:
          "Le fleuve Drâa est le plus long du Royaume avec plus de 1 100 km.",
    ),
    Question(
      questionText:
          "Selon le décret de 2015, de combien de régions se compose le Maroc ?",
      options: ["16 régions", "12 régions", "14 régions", "10 régions"],
      correctAnswerIndex: 1,
      explanation:
          "Le découpage territorial issu de la régionalisation avancée compte 12 régions.",
    ),
    Question(
      questionText:
          "Quelles entités composent les collectivités territoriales au Maroc ?",
      options: [
        "La wilaya, le pachalik et le cercle",
        "La région, la préfecture/province et la commune",
        "La région, la commune et le CRI",
        "La commune et l'arrondissement uniquement"
      ],
      correctAnswerIndex: 1,
      explanation:
          "Article 135 de la Constitution : régions, préfectures/provinces et communes.",
    ),
    Question(
      questionText:
          "Quel document décrit les dispositions techniques applicables aux marchés de même nature ?",
      options: [
        "Cahier des Prescriptions Communes (CPC)",
        "Cahier des Charges Générales (CCG)",
        "Acte d'engagement",
        "Bordereau des prix"
      ],
      correctAnswerIndex: 0,
      explanation:
          "Le CPC fixe les clauses techniques et particulières d'une catégorie de marchés.",
    ),
    Question(
      questionText:
          "Dans un tableur (Excel), quel symbole initie la saisie d'une formule ?",
      options: [
        "Parenthèse '('",
        "Signe égal '='",
        "Point d'exclamation '!'",
        "Dièse '#'"
      ],
      correctAnswerIndex: 1,
      explanation:
          "Le signe '=' informe le tableur qu'il s'agit d'un calcul ou d'une fonction.",
    ),
    Question(
      questionText:
          "Sous MS Access, quel objet permet de filtrer et d'extraire des données ?",
      options: ["Le rapport", "La table", "La requête", "Le formulaire"],
      correctAnswerIndex: 2,
      explanation:
          "La requête permet d'interroger la base de données selon des critères définis.",
    ),
  ];

  void _answerQuestion(int index) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isQuizFinished = _currentQuestionIndex >= _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prépa QCM Technicien"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isQuizFinished ? _buildResultScreen() : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQ = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 16.0),
        Text(
          "Question ${_currentQuestionIndex + 1}/${_questions.length}",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8.0),
        Text(
          currentQ.questionText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20.0),
        ...List.generate(currentQ.options.length, (index) {
          Color buttonColor = Colors.white;
          Color textColor = Colors.black;

          if (_hasAnswered) {
            if (index == currentQ.correctAnswerIndex) {
              buttonColor = Colors.green.shade100;
              textColor = Colors.green.shade900;
            } else if (index == _selectedAnswerIndex) {
              buttonColor = Colors.red.shade100;
              textColor = Colors.red.shade900;
            }
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: buttonColor,
                side: BorderSide(
                  color: _hasAnswered
                      ? (index == currentQ.correctAnswerIndex
                          ? Colors.green
                          : (index == _selectedAnswerIndex
                              ? Colors.red
                              : Colors.grey.shade300))
                      : Colors.blueAccent,
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 12.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onPressed: () => _answerQuestion(index),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  currentQ.options[index],
                  style: TextStyle(fontSize: 15.0, color: textColor),
                ),
              ),
            ),
          );
        }),
        const Spacer(),
        if (_hasAnswered) ...[
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "Explication : ${currentQ.explanation}",
              style: TextStyle(
                  color: Colors.blue.shade900, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 12.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14.0),
            ),
            onPressed: _nextQuestion,
            child: Text(
              _currentQuestionIndex == _questions.length - 1
                  ? "Voir les résultats"
                  : "Question suivante",
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildResultScreen() {
    double percentage = (_score / _questions.length) * 100;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
          const SizedBox(height: 16.0),
          const Text(
            "Test Terminé !",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Votre Score : $_score / ${_questions.length} (${percentage.toStringAsFixed(0)}%)",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton.icon(
            onPressed: _resetQuiz,
            icon: const Icon(Icons.replay),
            label: const Text("Recommencer le QCM"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

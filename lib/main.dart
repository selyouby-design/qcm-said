import 'package:flutter/material.dart';

void main() {
  runApp(const QcmApp());
}

class QcmApp extends StatelessWidget {
  const QcmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QCM Examen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Écran d'accueil
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préparation Examen - Technicien de 1er grade'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Bienvenue dans votre espace de révision QCM',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Testez vos connaissances pour réussir votre concours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Commencer le Quiz', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modèle de question
class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

// Écran du Quiz
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;

  // Liste des questions (Vous pouvez en rajouter facilement ici)
  final List<Question> _questions = [
    Question(
      questionText: 'Quel composant gère les adresses IP et le routage dans un réseau local ?',
      options: ['Le Switch (Commutateur)', 'Le Routeur', 'Le Hub', 'La Carte Réseau'],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Quel est le rôle principal d’une VLAN ?',
      options: [
        'Augmenter la vitesse physique du câble',
        'Segmenter un réseau physique en réseaux logiques distincts',
        'Remplacer complètement le protocole DHCP',
        'Chiffrer les données Wi-Fi'
      ],
      correctIndex: 1,
    ),
    Question(
      questionText: 'Dans un système Linux, quelle commande permet de visualiser l’utilisation de la mémoire RAM ?',
      options: ['ls -la', 'df -h', 'free -m', 'netstat'],
      correctIndex: 2,
    ),
  ];

  void _answerQuestion(int index) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _selectedAnswer = null;
      _answered = false;
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        // Fin du quiz, afficher le résultat ou retourner
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Terminé !'),
        content: Text('Votre score final est de : $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
              Navigator.pop(context); // Retourner à l'accueil
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1} / ${_questions.length}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              Color buttonColor = Colors.white;
              Color textColor = Colors.black;

              if (_answered) {
                if (index == question.correctIndex) {
                  buttonColor = Colors.green[100]!;
                  textColor = Colors.green[800]!;
                } else if (index == _selectedAnswer) {
                  buttonColor = Colors.red[100]!;
                  textColor = Colors.red[800]!;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(15),
                  ),
                  child: Text(
                    question.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  _currentIndex < _questions.length - 1 ? 'Question Suivante' : 'Voir le Résultat',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

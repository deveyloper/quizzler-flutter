import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:quizzler/question_source.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade800,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuestionSource questionSource = QuestionSource();

  List<Icon> scoreKeeper = [];

  void checkAnswer(bool userAnswer) {
    bool isUserAnswerTrue =
        questionSource.checkCurrentQuestionAnswer(userAnswer);
    if (isUserAnswerTrue) {
      scoreKeeper.add(
        Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }

    setState(() {
      if (questionSource.isFinished()) {
        int correntAnswerCount =
            scoreKeeper.where((s) => s.icon == Icons.check).length;
        int totalQuestionCount = scoreKeeper.length;
        Alert(
          context: context,
          title: 'Finished!',
          desc:
              'You\'ve reached the end of the quiz.\nCorrent answers: $correntAnswerCount / $totalQuestionCount',
        ).show();

        questionSource.resetQuestions();

        scoreKeeper = [];
      } else {
        questionSource.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FAProgressBar(
                backgroundColor: Colors.transparent,
                progressColor: Colors.white70,
                currentValue: questionSource.getQuestionNumber(),
                maxValue: questionSource.getTotalQuestionCount(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    questionSource.getNextQuestionText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scoreKeeper,
          ),
        ),
        //TODO: Add a Row here as your score keeper
      ],
    );
  }
}

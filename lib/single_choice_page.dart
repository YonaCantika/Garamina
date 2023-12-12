import 'dart:math';

import 'package:flutter/material.dart';

class SurveySingleChoicePage extends StatefulWidget {
  @override
  _SurveySingleChoicePageState createState() => _SurveySingleChoicePageState();
}

class _SurveySingleChoicePageState extends State<SurveySingleChoicePage> {
  List<Map<String, dynamic>> surveyQuestions = [];
  List<int?> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    generateRandomQuestions();
  }

  void generateRandomQuestions() {
    final random = Random();
    for (int i = 1; i <= 40; i++) {
      final options = List.generate(
          5, (index) => 'Pilihan ${String.fromCharCode(65 + index)}');
      surveyQuestions.add({
        'question': 'Pertanyaan ke-$i',
        'options': options,
      });
      selectedOptions.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Survey'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < surveyQuestions.length; i++) buildSurveyCard(i),
            ElevatedButton(
              onPressed: () {
                submitSurvey();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSurveyCard(int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              surveyQuestions[index]['question'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: List.generate(
                surveyQuestions[index]['options'].length,
                (optionIndex) {
                  return RadioListTile<int?>(
                    title: Text(surveyQuestions[index]['options'][optionIndex]),
                    value: optionIndex,
                    groupValue: selectedOptions[index],
                    onChanged: (value) {
                      setState(() {
                        selectedOptions[index] = value;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitSurvey() {
    // Lakukan sesuatu dengan jawaban yang disimpan di selectedOptions
    print('Jawaban Survey: $selectedOptions');
  }
}

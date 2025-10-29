import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BibleReaderScreen extends StatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  // Mock data for a verse from the Septuagint (Genesis 1:1)
  final String _verseText =
      "Ἐν ἀρχῇ ἐποίησεν ὁ θεὸς τὸν οὐρανὸν καὶ τὴν γῆν.";

  // Mock data for word context. In a real app, this would come from a database.
  final Map<String, Map<String, String>> _wordContextData = {
    "Ἐν": {"greek": "prep. in, on, at", "hebrew": "בְּ (be)"},
    "ἀρχῇ": {"greek": "n. beginning, origin", "hebrew": "רֵאשִׁית (reshit)"},
    "ἐποίησεν": {"greek": "v. made, created", "hebrew": "בָּרָא (bara)"},
    "ὁ": {"greek": "article. the", "hebrew": "(definite article)"},
    "θεὸς": {"greek": "n. God", "hebrew": "אֱלֹהִים (Elohim)"},
    "τὸν": {"greek": "article. the", "hebrew": "(definite article)"},
    "οὐρανὸν": {"greek": "n. heaven, sky", "hebrew": "שָׁמַיִם (shamayim)"},
    "καὶ": {"greek": "conj. and", "hebrew": "וְ (ve)"},
    "τὴν": {"greek": "article. the", "hebrew": "(definite article)"},
    "γῆν": {"greek": "n. earth, land", "hebrew": "אֶרֶץ (erets)"},
  };

  void _showWordContext(String word) {
    // Clean the word of punctuation for lookup
    String cleanedWord = word.replaceAll(RegExp(r'[.,!?;:]'), '');
    final contextData = _wordContextData[cleanedWord];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Context for "$cleanedWord"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contextData == null)
                const Text("No context available.")
              else
                const Text("Select a language for more information:"),
            ],
          ),
          actions: <Widget>[
            if (contextData != null) ...[
              TextButton(
                child: const Text('Greek'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showLanguageContext(cleanedWord, 'Greek', contextData['greek']!);
                },
              ),
              TextButton(
                child: const Text('Hebrew'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showLanguageContext(cleanedWord, 'Hebrew', contextData['hebrew']!);
                },
              ),
            ],
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLanguageContext(String word, String language, String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$language context for "$word"'),
          content: Text(info),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans() {
    final words = _verseText.split(' ');
    return words.map((word) {
      return TextSpan(
        text: "$word ",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22.0,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showWordContext(word);
          },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Septuagint Reader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            children: _buildTextSpans(),
          ),
        ),
      ),
    );
  }
}

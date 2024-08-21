import 'package:flutter/material.dart';
import 'package:majan_road/localization/app_localization.dart';

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _bugDescriptionController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xffF75D37),
        title: Text(
            AppLocalizations.of(context)?.translate('report a bug') ??
                'Report a Bug',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)?.translate('report a bug') ??
                    'Report a Bug',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff55A5A4)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bugDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                          ?.translate('bug_description') ??
                      'Describe the bug...',
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)
                          ?.translate('bug_description_label') ??
                      'Bug Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)
                            ?.translate('enter_bug_description') ??
                        'Please enter a description of the bug.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add your bug report submission logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)
                                  ?.translate('bug_reported') ??
                              'Bug reported!')),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)?.translate('submit') ??
                    'Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff55A5A4),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/api_key_cubit.dart';
import 'package:plane_alarm/widgets/my_top_app_bar.dart';

class InputApiKeyPage extends StatelessWidget {
  const InputApiKeyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyTopAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please enter your API key:'),
            SizedBox(height: 16),
            BlocBuilder<ApiKeyCubit, ApiKeyState>(
              builder: (context, state) {
                ApiKeyCubit apiKeyCubit = context.read<ApiKeyCubit>();
                TextEditingController inputController = TextEditingController();
                String apiKey = "";

                return Column(
                  children: [
                    TextField(
                      obscureText: false,
                      controller: inputController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            state is ApiKeyError
                                ? 'Invalid AeroAPI Key'
                                : 'AeroAPI Key',
                        labelStyle: TextStyle(
                          color: state is ApiKeyError ? Colors.red : null,
                        ),
                      ),
                      onSubmitted: (value) async {
                        apiKey = inputController.text;
                        await apiKeyCubit.inputApiKey(apiKey);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        apiKey = inputController.text;
                        await apiKeyCubit.inputApiKey(apiKey);
                      },
                    ),
                  ],
                );
              },
            ),
            // Add API key input field here
          ],
        ),
      ),
    );
  }
}

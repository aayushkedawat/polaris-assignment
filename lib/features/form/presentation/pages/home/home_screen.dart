import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polairs_assignment/core/constants/strings.dart';
import 'package:polairs_assignment/core/util/connectivity_check.dart';
import 'package:polairs_assignment/features/form/data/models/capture_images_model.dart';
import 'package:polairs_assignment/features/form/data/models/checkbox_model.dart';
import 'package:polairs_assignment/features/form/data/models/dropdown_model.dart';
import 'package:polairs_assignment/features/form/data/models/edit_text_model.dart';
import 'package:polairs_assignment/features/form/data/models/radiogroup_model.dart';
import 'package:polairs_assignment/features/form/domain/entities/form_field_entity.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_bloc.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_event.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/form_data/form_data_state.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/local/local_form_bloc.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/local/local_form_event.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/remote/remote_form_bloc.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/remote/remote_form_event.dart';
import 'package:polairs_assignment/features/form/presentation/bloc/remote/remote_form_state.dart';
import 'package:polairs_assignment/features/form/presentation/widgets/capture_image_widget.dart';
import 'package:polairs_assignment/features/form/presentation/widgets/edit_text_widget.dart';
import 'package:polairs_assignment/features/form/presentation/widgets/radiogroup_widget.dart';

import '../../widgets/checkbox_widget.dart';
import '../../widgets/dropdown_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> formResponses = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      BlocProvider.of<RemoteFormBloc>(context).add(const GetRemoteData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<FormDataBloc, FormDataState>(
        listener: (context, state) {
          if (state is FormDataAdded) {
            formResponses = state.data;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocBuilder<RemoteFormBloc, RemoteFormState>(
              builder: (context, state) {
                print('------>');
                print(state);
                print('------>');
                if (state is FormInitial) {
                  return Container();
                } else if (state is FormLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FormLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(state.formName ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.fields?.length ?? 0,
                          itemBuilder: (context, index) {
                            MetaInfo metaInfo = state.fields![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getDynamicWidget(metaInfo),
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: submitData,
                          child: const Text('Submit'),
                        )
                      ],
                    ),
                  );
                } else if (state is RemoteFormError) {
                  return Center(
                    child: Text(state.error?.message ?? ''),
                  );
                }
                // if (state is RemoteFormSubmitted) {
                //   print('state is RemoteFormSubimit');
                //   BlocProvider.of<RemoteFormBloc>(context)
                //       .add(const GetRemoteData());
                // }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void submitData() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (await ConnectivityCheck.isConnected()) {
        if (!mounted) {
          return;
        }
        BlocProvider.of<RemoteFormBloc>(context)
            .add(SubmitRemoteData([formResponses]));
      } else {
        if (!mounted) {
          return;
        }
        print('======>>> local');
        BlocProvider.of<RemoteFormBloc>(context)
            .add(AddLocalData(formResponses));
        // _formKey.currentState!.reset();
      }
      setState(() {
        formResponses = {};
      });
      BlocProvider.of<RemoteFormBloc>(context).add(const GetRemoteData());
    } else {
      Fluttertoast.showToast(msg: 'Please fill the form correctly');
    }
  }

  Widget getDynamicWidget(MetaInfo metaInfo) {
    String key = metaInfo.label!.replaceAll(' ', '_').toLowerCase();
    if (metaInfo is EditTextModel) {
      return EditTextWidget(
        editTextEntity: metaInfo.toEntity(),
        onChanged: (value) {
          BlocProvider.of<FormDataBloc>(context)
              .add(AddFormDataEvent(key: key, value: value));
        },
      );
    } else if (metaInfo is CaptureImageModel) {
      return CaptureImageWidget(
        captureImageEntity: metaInfo.toEntity(),
        onChanged: (value) {
          BlocProvider.of<FormDataBloc>(context)
              .add(AddFormDataEvent(key: key, value: value['aws']));
          List<String> alreadyImagePath = [];
          if (formResponses[metaInfo.savingFolder] != null) {
            alreadyImagePath = formResponses[metaInfo.savingFolder];
          }
          alreadyImagePath.addAll((value['local'] as List<String>));

          BlocProvider.of<FormDataBloc>(context).add(AddFormDataEvent(
              key: Strings.imagesLocalUpload,
              value: {metaInfo.savingFolder: alreadyImagePath}));
        },
      );
    } else if (metaInfo is RadioGroupModel) {
      return RadioGroupWidget(
        radioGroupEntity: metaInfo.toEntity(),
        onChanged: (value) {
          BlocProvider.of<FormDataBloc>(context)
              .add(AddFormDataEvent(key: key, value: value));
        },
      );
    } else if (metaInfo is CheckBoxModel) {
      return CheckboxWidget(
        checkBoxEntity: metaInfo.toEntity(),
        onChanged: (value) {
          BlocProvider.of<FormDataBloc>(context)
              .add(AddFormDataEvent(key: key, value: value.toString()));
        },
      );
    } else if (metaInfo is DropDownModel) {
      return DropdownWidget(
        dropDownEntity: metaInfo.toEntity(),
        onChanged: (value) {
          BlocProvider.of<FormDataBloc>(context)
              .add(AddFormDataEvent(key: key, value: value));
        },
      );
    } else {
      return Container();
    }
  }
}
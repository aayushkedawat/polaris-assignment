abstract class RemoteFormEvent {
  const RemoteFormEvent();
}

class GetRemoteData extends RemoteFormEvent {
  const GetRemoteData();
}

class SubmitRemoteData extends RemoteFormEvent {
  final List<Map<String, dynamic>> formDataMap;
  const SubmitRemoteData(this.formDataMap);
}

class AddLocalData extends RemoteFormEvent {
  final Map<String, dynamic> data;
  const AddLocalData(this.data);
}

class GetLocalData extends RemoteFormEvent {
  const GetLocalData();
}

class ClearLocalData extends RemoteFormEvent {
  const ClearLocalData();
}

class SyncData extends RemoteFormEvent {
  const SyncData();
}

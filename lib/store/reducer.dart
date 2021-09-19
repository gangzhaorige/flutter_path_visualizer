import 'package:flutter_path_visualizer/store/actions.dart';

import 'app_state.dart';



AppState appReducer(AppState state, action) {
  return AppState(
    brush: updateBrushReducer(state, action).brush,
    start: updateStartReducer(state, action).start,
    end: updateEndReducer(state, action).end,
  );
}



AppState updateBrushReducer(AppState state, dynamic action) {
  AppState updated = state;
  if(action is UpdateBrushAction) {
    updated.brush = action.updatedBrush;
    return updated;
  }
  return updated;
}

AppState updateStartReducer(AppState state, dynamic action) {
  AppState updated = state;
  if(action is UpdateStartAction) {
    print('Updating');
    updated.start = action.updatePosition;
    return updated;
  }
  return updated;
}

AppState updateEndReducer(AppState state, dynamic action) {
  AppState updated = state;
  if(action is UpdateStartAction) {
    updated.start = action.updatePosition;
    return updated;
  }
  return updated;
}
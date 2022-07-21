/*
 * Copyright (C) 2022 Application Library Engineering Group
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export enum DayState {
  NORMAL_DAY,
  TODAY_DAY,
  SELECTED_DAY,
  IN_RANGE_DAY
}

export enum CalendarType {
  SELECT_DATE,
  ENTER_DATE
}

export enum PickerType {
  DATE_PICKER,
  DATE_RANGE_PICKER
}

export const Calendar =
  {
    month: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    weekdays: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
  }

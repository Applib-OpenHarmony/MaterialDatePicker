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

import { CalendarType, PickerType } from './Values'

export interface DatePickerOptions {
  picker?: PickerType
  inputMode?: CalendarType
  startYear?: number
  endYear?: number
  openAtYear?: number
  openAtMonth?: number
  themeColor?: Color
  titleStyle?: {
    textLabel?: string
    textColor?: Color
  }
  selectedDateStyle?: {
    textColor?: Color
  }
  monthStyle?: {
    textColor?: Color
    todayDateTextColor?: Color
    todayDateBorderWidth?: number
    todayDateBorderColor?: Color
    todayDateFillColor?: Color
    itemFillColor?: Color
    itemStrokeColor?: Color
    itemStrokeWidth?: number
    rangeFillColor?: Color
  }
  cancelButtonStyle?: {
    textColor?: Color
  }
  confirmButtonStyle?: {
    textColor?: Color
    itemFillColor?: Color
  }

}

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

import { MaterialDatePicker, CalendarType, PickerType } from '@ohos/MaterialDatePicker'

@Entry
@Component
struct DemoScreen {
  @State showSelectedDate: string = "Select date";
  @State showSelectedRange: string = "Select range";
  datePicker: CustomDialogController = new CustomDialogController({
    builder: MaterialDatePicker({
      confirm: (value) => this.onAccept(value),
      cancel: this.exitApp,
      options: {
        picker: PickerType.DATE_PICKER,
        inputMode: CalendarType.SELECT_DATE,
        startYear: 2000,
        endYear: 2030,
        openAtYear: 2022,
        openAtMonth: 6,
        themeColor: 0x5e00ff,
        titleStyle: {
          textLabel: "Select date",
          textColor: Color.White
        },
        selectedDateStyle: {
          textColor: Color.White
        },
        monthStyle: {
          itemFillColor: 0x5e00ff
        },
        cancelButtonStyle: {
          textColor: Color.Grey
        },
        confirmButtonStyle: {
          textColor: Color.White,
          itemFillColor: 0x5e00ff
        }
      }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  });

  onAccept(value: string) {
    this.showSelectedDate = value;
  }

  rangePicker: CustomDialogController = new CustomDialogController({
    builder: MaterialDatePicker({
      confirm: (value) => this.onAcceptRange(value),
      cancel: this.exitApp,
      options: {
        picker: PickerType.DATE_RANGE_PICKER,
        inputMode: CalendarType.ENTER_DATE,
        startYear: 2000,
        endYear: 2030,
        openAtYear: 2022,
        openAtMonth: 6,
        themeColor: 0x5e00ff,
        titleStyle: {
          textLabel: "Select range",
          textColor: Color.White
        },
        selectedDateStyle: {
          textColor: Color.White
        },
        monthStyle: {
          itemFillColor: 0x5e00ff,
          rangeFillColor: 0xece0fd
        },
        cancelButtonStyle: {
          textColor: Color.Grey
        },
        confirmButtonStyle: {
          textColor: Color.White,
          itemFillColor: 0x5e00ff
        }
      }
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Center,
  });

  onAcceptRange(value: string) {
    this.showSelectedRange = value;
  }

  exitApp() {
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start }) {
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.menu")).width(30).height(30)
        }.width(30).height(30).margin({ left: 10 }).backgroundColor(Color.White)

        Text('Date Picker')
          .fontFamily("San Francisco")
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 20, bottom: 20 })
      }

      Divider().width('100%').strokeWidth(4).color(0xEAEAEA)
      Flex({ justifyContent: FlexAlign.Start }) {
        Text("Select Date").fontFamily("Times New Roman").fontSize(20).margin({ left: 15, top: 20, bottom: 20 })
      }

      Flex({ justifyContent: FlexAlign.Start }) {
        Text("Start").fontFamily("Times New Roman").fontSize(15).margin({ left: 15, bottom: 15 })
      }

      Flex({ justifyContent: FlexAlign.Start }) {
        Column() {
          Row() {
            Text(this.showSelectedDate).fontSize(15)
          }.width('100%').padding(5)
        }
        .alignSelf(ItemAlign.Center)
        .borderWidth(1)
        .borderColor(Color.Grey)
        .width('75%')
        .height(30)
        .margin({ left: 15 })

        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.range_calendar")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick(() => {
              this.datePicker.open()
            })
          }.padding(5)
        }.borderWidth(1).borderColor(Color.Grey).width('10%').height(30)
      }.margin({ bottom: 15 })

      Flex({ justifyContent: FlexAlign.Start }) {
        Text("Select Range").fontFamily("Times New Roman").fontSize(20).margin({ left: 15, top: 20, bottom: 20 })
      }

      Flex({ justifyContent: FlexAlign.Start }) {
        Text("Start - End").fontFamily("Times New Roman").fontSize(15).margin({ left: 15, bottom: 15 })
      }

      Flex({ justifyContent: FlexAlign.Start }) {
        Column() {
          Row() {
            Text(this.showSelectedRange).fontSize(15)
          }.width('100%').padding(5)
        }
        .alignSelf(ItemAlign.Center)
        .borderWidth(1)
        .borderColor(Color.Grey)
        .width('75%')
        .height(30)
        .margin({ left: 15 })

        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              Image($r("app.media.range_calendar")).width(20).height(20)
            }.width(20).height(20).backgroundColor(Color.White)
            .onClick(() => {
              this.rangePicker.open()
            })
          }.padding(5)
        }.borderWidth(1).borderColor(Color.Grey).width('10%').height(30)
      }.margin({ bottom: 15 })
    }

  }
}

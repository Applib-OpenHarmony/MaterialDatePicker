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

import { DatePickerModel } from './DatePickerModel'
import { PickerType } from './Values'

@Component
struct datePickerInput {
  @Link parentModel: DatePickerModel
  @State inputDate: string = "dd/mm/yyyy"
  @State startDate: string = "dd/mm/yyyy"
  @State endDate: string = "dd/mm/yyyy"
  switchCalendar: () => void
  closeDialog: () => void
  sendDate: (string) => void

  isAhead(value: string): boolean{
    var temp = this.startDate.split("/")
    var date = parseInt(temp[0])
    var month = parseInt(temp[1])
    var year = parseInt(temp[2])
    var startDate: Date = new Date(year, month, date)

    temp = value.split("/")
    date = parseInt(temp[0])
    month = parseInt(temp[1])
    year = parseInt(temp[2])
    var endDate: Date = new Date(year, month, date)
    if (endDate >= startDate) return true;
    else return false;
  }

  isValidDateFormat(value: string): boolean{
    var temp = value.split("/")
    if (temp.length != 3) return false;
    var date = parseInt(temp[0])
    var month = parseInt(temp[1])
    var year = parseInt(temp[2])
    if (String(date) == "NaN" || date < 1 || date > 31) return false;
    if (String(month) == "NaN" || month < 1 || month > 12) return false;
    if (String(year) == "NaN" || year < this.parentModel.startYear || year > this.parentModel.endYear) return false;
    var dt: Date = new Date(year, month, 1);
    var maxDays: number = new Date(dt.getFullYear(), dt.getMonth(), 0).getDate();
    if (date > maxDays) return false;
    return true;
  }

  isValidRangeFormat(value: string): boolean{
    if (!this.isValidDateFormat((value))) return false;
    if (!this.isAhead(value)) return false;
    return true;
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start }) {
        Text((this.parentModel.picker == PickerType.DATE_RANGE_PICKER) ? "INPUT RANGE" : "INPUT DATE")
          .fontColor(Color.White)
          .fontSize("15fp")
          .fontWeight("550vp")
          .fontFamily('Times')
          .margin({ left: "10vp", top: "10vp" })

      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height("60vp")

      Flex({ justifyContent: FlexAlign.SpaceBetween }) {
        Text((this.parentModel.picker == PickerType.DATE_RANGE_PICKER) ? "Enter Range" : "Enter Date")
          .fontColor(Color.White)
          .fontSize("30fp")
          .fontFamily('Times')
          .margin({ left: "10vp" })
        Button({ type: ButtonType.Circle }) {
          Image($r("app.media.calendar")).width("25vp").height("25vp")
        }
        .width("30vp")
        .height("30vp")
        .margin({ right: "40vp" })
        .backgroundColor(this.parentModel.themeColor)
        .onClick(() => {
          this.switchCalendar();
        })
      }
      .backgroundColor(this.parentModel.themeColor)
      .width('100%')
      .height("50vp")
      .margin({ bottom: "20vp" })

      Row() {
        if (this.parentModel.picker == PickerType.DATE_PICKER) {
          Column() {
            TextInput({ placeholder: 'dd/mm/yyyy' })
              .type(InputType.Normal)
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: "15fp", weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal })
              .enterKeyType(EnterKeyType.Next)
              .caretColor(Color.Blue)
              .width('90%')
              .height("40vp")
              .margin({ bottom: "20vp" })
              .fontSize("15fp")
              .fontColor(Color.Black)
              .maxLength(10)
              .onChange((value: string) => {
                this.inputDate = value;
              })
          }
        }
        else {
          Column() {
            Row() {
              Text("Start date").fontSize("15fp").fontColor(Color.Black).fontWeight("550vp")
            }.width('70%').margin({ bottom: "5vp" })

            TextInput({ placeholder: 'dd/mm/yyyy' })
              .type(InputType.Normal)
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: "15fp", weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal })
              .enterKeyType(EnterKeyType.Next)
              .caretColor(Color.Blue)
              .width('90%')
              .height("40vp")
              .margin({ bottom: "20vp" })
              .fontSize("15fp")
              .fontColor(Color.Black)
              .maxLength(10)
              .onChange((value: string) => {
                this.startDate = value;
              })
              .onSubmit(() => {
                if (!this.isValidDateFormat(this.startDate)) {
                  AlertDialog.show(
                    {
                      title: 'Invalid Date',
                      message: 'Input the correct date in dd/mm/yyyy format',
                      primaryButton: {
                        value: 'OK',
                        action: () => {
                        }
                      },
                      cancel: () => {
                      }
                    }
                  )
                }
              })
          }.width('50%')

          Column() {
            Row() {
              Text("End date").fontSize("15fp").fontColor(Color.Black).fontWeight("550vp")
            }.width('70%').margin({ bottom: "5vp" })

            TextInput({ placeholder: 'dd/mm/yyyy' })
              .type(InputType.Normal)
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: "15fp", weight: FontWeight.Normal, family: "sans-serif", style: FontStyle.Normal })
              .enterKeyType(EnterKeyType.Next)
              .caretColor(Color.Blue)
              .width('90%')
              .height("40vp")
              .margin({ bottom: "20vp" })
              .fontSize("15fp")
              .fontColor(Color.Black)
              .maxLength(10)
              .onChange((value: string) => {
                this.endDate = value;
              })
          }.width('50%')
        }

      }

      Flex({ justifyContent: FlexAlign.End }) {
        Button("Cancel", { type: ButtonType.Normal })
          .width("100vp")
          .backgroundColor(Color.White)
          .fontColor(Color.Grey)
          .fontWeight("550vp")
          .onClick(() => {
            this.closeDialog();
          })
          .padding(10)
        Button("Ok", { type: ButtonType.Normal })
          .width("100vp")
          .backgroundColor(this.parentModel.themeColor)
          .borderRadius("2vp")
          .fontWeight("550vp")
          .fontSize("18fp")
          .onClick(() => {
            if (this.parentModel.picker == PickerType.DATE_PICKER) {
              if (this.isValidDateFormat(this.inputDate)) {
                this.sendDate(this.inputDate);
                this.closeDialog();
              }
              else {
                AlertDialog.show(
                  {
                    title: 'Invalid Date',
                    message: 'Input the correct date in dd/mm/yyyy format',
                    primaryButton: {
                      value: 'OK',
                      action: () => {
                      }
                    }
                  }
                )
              }
            }
            else {
              if (this.isValidRangeFormat(this.endDate)) {
                this.sendDate(this.startDate + " - " + this.endDate)
                this.closeDialog();
              }
              else {
                AlertDialog.show(
                  {
                    title: 'Invalid Range',
                    message: 'Input a valid range with each date in dd/mm/yyyy format',
                    primaryButton: {
                      value: 'OK',
                      action: () => {
                      }
                    }
                  }
                )
              }
            }

          })
          .padding(10)
      }.width('100%').height("40vp").margin({ right: "20vp", bottom: "10vp" })
    }
    .clip(true)
    .borderRadius("22vp")
  }
}

export default datePickerInput

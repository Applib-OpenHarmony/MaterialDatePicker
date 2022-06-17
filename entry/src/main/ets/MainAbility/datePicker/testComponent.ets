@Component
struct testComponent{
  private testModel: testComponent.Model = new testComponent.Model();
  build(){
    Text(this.testModel.testingFeature+'').fontSize(40).fontWeight(FontWeight.Bold)
  }
}

namespace testComponent{
  export class Model{
    testingFeature: number = 7;
  }
}

export default testComponent;
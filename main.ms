
Import quickchart as lib

Application {
    Array<String> selectedCont
    Array<Country> tt
    Timer time
    
    OnInit {
        time = Timer(delay:1, function:@function(MainModule.check), repeat:false)
        Welcome w = Welcome()
        broker.ui.push("Welcome", w)
        time.start()
        selectedCont = []  
    }
}

Experience Welcome {
    String img value("https://imgur.com/n0vZiFA.png") as Image
    String title value("COVID-19 Charts") as Label
}

Experience Main {
    Array<String> tipo value(["Show All", "Confirmed", "Deaths", "Recovered"]) as Select
    Array<String> selectCountries value(["Show All"]) as Select
    
    String chart as Image
    
    Decision btn action("MainContext.getChart") label("Get Chart!")
    
    OnCreate{
        Main exp = broker.ui.getDataSource()
        
        tt = service.end.call()
        
        //Array<Integer> confirmed
        //Array<String> dates
        for t in tt{
            Bool s = false
            for k in exp.selectCountries{
                if(t.country==k){
                   s = true
                }
            }
            
            if(s==false){
                exp.selectCountries.add(t.country)
            }
            //if(t.country=="Argentina"){
            //    confirmed = t.timeline.cases.values()
            //    dates = t.timeline.cases.keys()
            //}
        }
        
        //lib::DataSet set1 = lib::DataSet(label:"Confirmed", data:confirmed)
        //Array<lib::DataSet> arrayDS = [set1]
        //lib::Data data = lib::Data(labels:dates, datasets:arrayDS)
        //String response = lib::GetChart.getChart("line", data, lib::Options())
        
        
        //exp.chart=response
        
    }
}

Model Country {
    String country
    Timeline timeline
}

Model Timeline {
    Map<Integer> cases
    Map<Integer> deaths
    Map<Integer> recovered
}

RuleContext MainContext {
    Rule clear {
        Main exp = broker.ui.getDataSource()
        exp.chart = ""
        selectedCont = []
        broker.ui.showAlert("Clear Data!", "")
    }
    
    Rule selection {
        Main exp = broker.ui.getDataSource()
        Integer index = exp.selectCountries.selected().get(0)
        String name = exp.selectCountries.get(index)
        selectedCont.add(name)
        broker.ui.showAlert("Selected:", name)
    }
    
    Rule getChart{
        Main exp = broker.ui.getDataSource()
        Integer index = exp.tipo.selected().get(0)
        String name = exp.tipo.get(index)
        
        Array<Array<Integer>> dataC = []
        Array<String> dates = []
        
        //broker.ui.showAlert("",tt.size().toString())
        
        tt = MainModule.func(tt)
        if(name == "Confirmed"){
        
            for k in selectedCont {
                for u in tt {
                    if(k==u.country){
                        //broker.ui.showAlert("","Hola")
                        dataC.add(u.timeline.cases.values()) ///////////
                        dates = u.timeline.cases.keys()
                    }
                }
            }
        
        }
        
        if(name == "Deaths"){
        
            for k in selectedCont {
                for u in tt {
                    if(k==u.country){
                        //broker.ui.showAlert("","Hola")
                        dataC.add(u.timeline.deaths.values()) ///////////
                        dates = u.timeline.deaths.keys()
                    }
                }
            }
        
        }
        
         if(name == "Recovered"){
        
            for k in selectedCont {
                for u in tt {
                    if(k==u.country){
                        //broker.ui.showAlert("","Hola")
                        dataC.add(u.timeline.recovered.values()) ///////////
                        dates = u.timeline.recovered.keys()
                    }
                }
            }
        
        }
        
        
        //broker.ui.showAlert("",dataC.size().toString())
        Array<lib::DataSet> arrayDS = []
        Integer count = 0
        for m in dataC{
            arrayDS.add(lib::DataSet(label:selectedCont.get(count), data:m, fill:true))
            count=count+1
        }
        
        lib::Data data = lib::Data(labels:dates, datasets:arrayDS)
        String response = lib::GetChart.getChart("line", data, lib::Options())
        exp.chart = response
        
        
        
        
    }
}

Module MainModule{
    void check(Timer timee){
        Main exp = Main()
        broker.ui.push("Main", exp)
    }
    
    Array<Country> func(Array<Country> original){
        Array<Country> c = []
        
        c.add(tt.get(0))
        Integer con = 0
        
        for k in tt{
            if(con!=0){
                Bool s = false
                for m in c {
                    if(k.country==m.country){
                        //m.timeline.cases = MainModule.sumMaps(m.timeline.cases, k.timeline.cases)
                        //m.timeline.deaths = MainModule.sumMaps(m.timeline.deaths, k.timeline.deaths)
                        //m.timeline.recovered = MainModule.sumMaps(m.timeline.recovered, k.timeline.recovered)
                        s = true
                    }
                }
                if(s==false){
                    c.add(k)
                }
                
                
            }
            ++con
        }
        
        return c
    }
    
    Map<Integer> sumMaps(Map<Integer> m1, Map<Integer> m2){
        Map<Integer> result = {}
        
        Array<Integer> mm1 = m1.values()
        Array<Integer> mm2 = m2.values()
        Array<String> m = m1.keys()
        Integer count=0
        while(count<mm1.size()){
            mm1.get(count) = mm1.get(count) + mm2.get(count) 
            ++count
        }
        
        count=0
        while(count<mm1.size()){
            result.set(m.get(count), mm1.get(count))
            ++count
        }
        
        return result
    }

}

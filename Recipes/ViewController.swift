import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var lowSugarBtn: UIButton!
    @IBOutlet weak var ketoBtn: UIButton!
    @IBOutlet weak var veganBtn: UIButton!
    
    var recipesArr = [Recipes]()
    let app_id:String = "b3c6ace0"
    let app_key:String = "3c71f4ec5817e262c94c03100136eff3"
    var health_filter:String = ""
    var selectedRecipe: Recipes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes Search"
        table.register(RecipeTableViewCell.nib(), forCellReuseIdentifier: RecipeTableViewCell.identifier )
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    @IBAction func onClickAll(_ sender: UIButton) {
        resetButtons()
        health_filter = ""
        searchRecipes()
        allBtn.isSelected = true
    }
    
    @IBAction func onClickLowSugar(_ sender: UIButton) {
        resetButtons()
        health_filter = "&health=low-sugar"
        searchRecipes()
        lowSugarBtn.isSelected = true
    }
    
    @IBAction func onClickKeto(_ sender: UIButton) {
        resetButtons()
        health_filter = "&health=keto-friendly"
        searchRecipes()
        ketoBtn.isSelected = true
    }
    
    @IBAction func onClickVegan(_ sender: UIButton) {
        resetButtons()
        health_filter = "&health=vegan"
        searchRecipes()
        veganBtn.isSelected = true
    }
    
    func resetButtons(){
        allBtn.isSelected = false
        lowSugarBtn.isSelected = false
        ketoBtn.isSelected = false
        veganBtn.isSelected = false
    }
    
    //Alert
    func doAlert(str: String){
        let alert = UIAlertController(title: "Alert", message: str, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //field
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchRecipes()
        return true
    }
    
    func checkCharInField(str:String) -> Bool{
        do{
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: str, options: [], range: NSMakeRange(0, str.count)) != nil {
                doAlert(str: "Only english letters & spaces are allowed")
                return false
                }
        }
        catch{
        }
        return true
    }
    
    func searchRecipes(){
        field.resignFirstResponder()
        guard let searchWord = field.text, !searchWord.isEmpty else{
            doAlert(str: "Please enter a recipe")
            return
        }
        if !checkCharInField(str: searchWord){
            return
        }
        let q = searchWord.replacingOccurrences(of: " ", with: "%20")
        recipesArr.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.edamam.com/search?q=\(q)&app_id=\(app_id)&app_key=\(app_key)\(health_filter)")!, completionHandler: {data, response,error in
            guard let data = data, error == nil  else{
                return
            }
                         
            //convert data
            var result: RecipeResult?
            do{
                result = try JSONDecoder().decode(RecipeResult.self, from: data)
            }
            catch{
                print("error")
            }
            guard let finalResult = result else{
                 return
            }
                        
            //update our movie array
            let newRecipes = finalResult.hits
            self.recipesArr.append(contentsOf: newRecipes)
            
            //update table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }

    //table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  RecipeTableViewCell.identifier, for: indexPath) as! RecipeTableViewCell
        cell.configure(with: recipesArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRecipe = recipesArr[indexPath.row]

//        let destinationVC = DetailsViewController()
//        destinationVC.recipe = selectedRecipe
//            destinationVC.configureDetails(with: selectedRecipe)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secVC: DetailsViewController = segue.destination as! DetailsViewController
            secVC.recipe = selectedRecipe
    }
}

struct RecipeResult: Codable{
    let hits: [Recipes]
    
}

struct Recipes: Codable{
    let recipe: Recipe
}

struct Recipe: Codable{
    let image: String
    let label: String
    let source: String
    let healthLabels: [String]
    let ingredientLines: [String]
    let url: String
}

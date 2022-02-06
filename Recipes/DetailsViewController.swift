import UIKit
import SafariServices

class DetailsViewController: UIViewController{
    @IBOutlet weak var titleLabelView: UILabel!
    @IBOutlet weak var ingredientsLabelView: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var websiteButton: UIButton!
    var url: String = ""
    
    var recipe: Recipes?
    
    //Buttons
    @IBAction func onClickShare(_ sender: UIButton) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: Any) {
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes Details"
        configureDetails(with: recipe!)
    }
    
    func configureDetails(with model: Recipes){
        self.titleLabelView.text = model.recipe.label
        self.ingredientsLabelView.text = modifyIngredients(ingredientsLines: model.recipe.ingredientLines)
        self.url = model.recipe.url
        let url = model.recipe.image
        
        if let data = try? Data(contentsOf: URL(string:url)!){
            self.recipeImageView.image = UIImage(data: data)
        }
    }
    
    func modifyIngredients(ingredientsLines: [String])-> String{
        var str: String = ""
        for s in ingredientsLines {
            str += s
            str += "\n"
        }
        return str
    }
    
    
}


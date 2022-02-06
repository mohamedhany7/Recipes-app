import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var RecipeTitleLabel: UILabel!
    @IBOutlet var RecipeSourceLabel: UILabel!
    @IBOutlet var RecipeHealthLabel: UILabel!
    @IBOutlet var RecipeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "RecipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RecipeTableViewCell", bundle: nil)
    }
    
    func configure(with model: Recipes){
        self.RecipeTitleLabel.text = model.recipe.label
        self.RecipeSourceLabel.text = model.recipe.source
        self.RecipeHealthLabel.text = modifyHealthLabels(healthLabels: model.recipe.healthLabels)
        let url = model.recipe.image

        if let data = try? Data(contentsOf: URL(string:url)!){
            self.RecipeImageView.image = UIImage(data: data)
        }
    }
    
    func modifyHealthLabels(healthLabels: [String]) -> String{
        var str: String = ""
        for s in healthLabels {
            str += s
            str += ", "
        }
        str.removeLast()
        str.removeLast()
        return str
    }
}

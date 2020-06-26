//
//  ExploreOptionsController.swift
//  InTune
//
//  Created by Tiffany Obi on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

protocol UpdateUsertPref:AnyObject {
    func didUpdatePreferences(_ tags: [String], _ exploreVC:ExploreOptionsController)
}


class ExploreOptionsController: UIViewController {
    
    
    @IBOutlet weak var instrumentsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var instruments = [String]()
    var genres = [String]()
    
    //    var selectedInstruments = Set<String>()
    //    var selectedGenres = Set<String>()
    
    var selectedTags = Set<String>()
    
    var instrumentIndex: Int?
    var genreIndex: Int?
    let db = DatabaseService()
    
    //     private var tagsObserver: NSKeyValueObservation?
    
    weak var prefDelegate: UpdateUsertPref?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionViews()
        loadCollectionViews()
    }
    
    func setUpCollectionViews(){
        instrumentsCollectionView.dataSource = self
        instrumentsCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
        instrumentsCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        
        genresCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tagCell")
    }
    
    private func loadCollectionViews(){
        instruments = Tags.instrumentList
        genres = Tags.genreList
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard !selectedTags.isEmpty else {return}
        
        db.updateUserPreferences(Array(selectedTags)) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
            case.success:
                print(true)
                
                self?.prefDelegate?.didUpdatePreferences(Array(self?.selectedTags ?? [""]), self ?? ExploreOptionsController())
                
                self?.dismiss(animated: true)
                
            }
        }
        
    }
    
}

extension ExploreOptionsController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == instrumentsCollectionView {
            return instruments.count
        }
        
        if collectionView == genresCollectionView{
            return genres.count
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == instrumentsCollectionView {
            
            guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else {
                fatalError("could not downcast to TagCollectionViewCell")
            }
            let instrument = instruments[indexPath.row]
            tagCell.tagTitle.backgroundColor = .black
            tagCell.layer.borderWidth = 4
            tagCell.layer.borderColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
            tagCell.tagsDelegate = self
            
            tagCell.tagTitle.text = instrument
            tagCell.instrument = instrument
            tagCell.tagTitle.textColor = .white
            return tagCell
            
        }
        if collectionView == genresCollectionView{
            guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell else { fatalError("could not downcast to TagCollectionViewCell")
            }
            
            let genre = genres[indexPath.row]
            tagCell.tagTitle.backgroundColor = .black
            tagCell.layer.borderWidth = 4
            tagCell.layer.borderColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
            tagCell.tagsDelegate = self
            tagCell.genre = genre
            tagCell.tagTitle.textColor = .white
            tagCell.tagTitle.text = genre
            
            return tagCell
        }
        
        return TagCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width * 0.25
        let itemHeight: CGFloat = maxSize.height * 0.10
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        if collectionView == instrumentsCollectionView {
    //
    //            let selectedInstrument = instruments[indexPath.row]
    //            instrumentIndex = indexPath.row
    //            selectedTags.insert(selectedInstrument)
    //            print(selectedTags)
    //
    //        }
    //
    //        if collectionView == genresCollectionView {
    //
    //            let selectedGenre = genres[indexPath.row]
    //            genreIndex = indexPath.row
    //            selectedTags.insert(selectedGenre)
    //
    //            print(selectedTags)
    //        }
    //    }
    
    
}

extension ExploreOptionsController: TagsCVDelegate {
    func updateUserPreferences(_ isPicked: Bool, _ cell: TagCollectionViewCell, instrument: String, genre: String) {
        
        if !instrument.isEmpty {
            selectedTags.insert(instrument)
        }
        if !genre.isEmpty {
            selectedTags.insert(genre)
        }
        
        print(selectedTags)
    }
    
    
    
}

//
//  TranslateViewController.swift
//  AiTryApp
//
//  Created by SASE Koichiro on 2020/07/22.
//  Copyright © 2020 SASE Koichiro. All rights reserved.
//

import UIKit
import MLKit

class TranslateViewController: UIViewController {
    
    var baseText = ""
    var translatedText = ""
    
    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        translate()

    }

    @IBAction func reTranslateButton(_ sender: Any) {
        
        baseText = baseTextView.text
        
        translate()
        
    }
    
    
    func translate() {
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .japanese)
        let englishJapaneseTranslator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
        englishJapaneseTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            englishJapaneseTranslator.translate(self.baseText) { translatedText, error in
                guard error == nil, let translatedText = translatedText else { return }
                self.translatedText = translatedText
                self.translatedTextView.text = translatedText
            }

        }
    }


}


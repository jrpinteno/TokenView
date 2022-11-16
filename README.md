# TokenView

View container based on `UICollectionView` used to display tokens. It also allows adding new ones through `UITextField` entry and possibility to attach a picker selection view.


## Installation

### CocoaPods

TokenView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TokenView'
```


## **Known issues**
- [x] Picker doesn't disappear when token is added through text change (delimiters)


## **TODO**

- [x] Toggleable prompt

- [x] Deletable tokens

- [ ] Customizable appearance per token

- [ ] Custom token protocol to allow custom UICollectionViewCell subclasses for appearance and behaviour

- [x] Optional validation for token generation

- [ ] Long tap detection (or second tap after token is selected) to handle secondary action

- [x] Dropdown selector from external datasource to add token

- [ ] Support for right-to-left languages

- [ ] Support self-sizing cells through autolayout

- [x] Custom delimiters detection on text entry for token generation 

- [ ] Toggle showing picker elements which have been already added 

- [x] Show preloaded tokens


## Author

Xavi R. Pinteño, xavi@jrpinteno.me


## License

TokenView is available under the MIT license. See the [LICENSE](https://github.com/jrpinteno/TokenView/blob/main/LICENSE) file for more info.

# TokenView

View container based on `UICollectionView` used to display tokens. It also allows adding new ones through `UITextField` entry and possibility to attach a picker selection view.


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

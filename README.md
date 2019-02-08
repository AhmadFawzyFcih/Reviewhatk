# Fustany Task
1-this is a simple application through it you can create your account and login to :
   - create products and browse the home page to see other products.
   - you can add/remove products to/from your favorite list.
   - you can display your favorite list product
   - you can filter your home page by categories
   - you can add new categories. 
 
2-here our installation steps to run the project :
  - download the project
  - create your mysql database
  - enter to the peoject : cd "your project name"
  - run this command to install your gems : bundle install
  - run the database migrations : rails db:migrate
  - run your database seed file to intialize your database with some default data : rails db:seed 
  - run your project with this command : rails s
  
3-to add new product or category or add product to your favorite list through apis :
  - add new category : http://localhost:3000/api/v1/categories
  - add new product  : http://localhost:3000/api/v1/products
  - add product to favorite list : http://localhost:3000/api/v1/products/favorite

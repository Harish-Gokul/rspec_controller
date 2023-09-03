require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do

  describe "Testing routes which is responsible to show Articles" do

    let!(:article)  {Article.create(title: "New Article",description: "This is one of the new article")}

    context "Testing index action- (GET index)" do
      it "Testing weather it is rendering template" do
        get :index
        expect(response).to render_template("index")
      end

      it "Testing Article instance variable for latest created record" do
        get :index
        instanceVariable = assigns(:articles)
        expect(instanceVariable).to eq([article])
      end

      it "Testing the status code" do
        get :index
        expect(response).to have_http_status(200)
      end

      it "Expecting to be successful" do
        get :index
        expect(response).to be_successful
      end

      it "Testing Article instance variable count" do
        get :index
        expect(assigns(:articles).count).to eq(1)
      end
    end

    context "Testing Show Action (Get /articles/:id)" do

      it 'Testing Weather it renders template' do
        get :show, params: {id:article.id}
        expect(response).to render_template("show")
      end

      it "Expecting to be successful" do
        get :show, params: {id:article.id}
        expect(response).to be_successful
      end

      it 'Testing show with invalid id' do
        get :show, params: {id:99}
        expect(assigns(:article)).to eq(nil)
      end

      it "instance variable should have the same name method in the parameter" do
        get :show, params: {id:article.id}
        expect(assigns(:article).title).to eq(article.title)
      end

    end
  end

  describe "Testing routes which is responsible for create a new article" do

    context "Testing  to the ui page for new Action (Get /articles/new)" do
      it 'should render the new template' do
        get :new
        expect(response).to render_template("new")
      end

      it 'should have success status code' do
        get :new
        expect(response).to have_http_status(200)
      end

      it 'Expecting to be successful' do
        get :new
        expect(response).to be_successful
      end
    end

    context "Testing  behind the scenes Create Action - (Post:/articles)" do
      subject{ {title:"Testing new create route",description:"Working on create routes testing"}}
      it 'should be successful' do
        post :create, params:{article: subject}
        expect(response).to have_http_status(302)
      end

      it "Latest record should match parameter" do
        post :create, params:{article:subject}
        expect(Article.last.title).to eq(subject[:title])
      end

      it "Testing weather it is redirecting to show page" do
        post :create, params:{article:subject}
        expect(response).to redirect_to(article_url(Article.last.id))
      end

      it "Testing render new page while entering wrong data" do
        post :create, params:{article: {description:"This is one the best description"}}
        expect(response).to render_template("new")
      end

      it "Testing the instance variable to have the same details mentioned in the params" do
        post :create, params:{article: subject}
        instanceVariable = assigns(:article)
        expect(instanceVariable.title).to eq(subject[:title])
      end

      it 'should flash the notice with "Article created successfully"' do
        post :create, params:{article: subject}
        expect(flash[:notice]).to eq("Article was successfully created.")
      end

    end

  end

  describe "Testing routes which is responsible for editing article" do
    let(:article){Article.create(title:"Testing editing route",description: "Testing edit routes from end to end")}

    context "Testing the UI page, Edit action - (GET /articles/:id/edit)" do
      it 'should be successful with proper valid article id' do
        get :edit, params:{id:article.id}
        expect(response).to be_successful
      end

      it "Instance variable should match with article record" do
        get :edit, params:{id:article.id}
        instanceVariable = assigns(:article)
        expect(instanceVariable.title) .to eq(article.title)
      end

      it "Should render the edit view file" do
        get :edit, params:{id:article.id}
        expect(response).to render_template("edit")
      end

      it "Should return 404 status code if invalid id is entered" do
        get :edit, params:{id:99}
        expect(response).to have_http_status(404)
      end

    end

    context "Testing the behind the scenes Update Action (patch /articles/id)" do
      subject{{title:"edited article title", description:"Edited description also"}}

      it 'Testing for redirection to show page after successful updation' do
        patch :update, params:{id:article.id,article:subject}
        expect(response).to redirect_to(article_url(article.id))
      end

      it "Testing the flash notification" do
        patch :update, params:{id:article.id,article:subject}
        expect(flash[:notice]).to eq("Article was successfully updated.")
      end

      it "Does the record got updated with the new value" do
        patch :update, params:{id:article.id,article:subject}
        article.reload
        expect(article.title).to eq(subject[:title])
      end

      it "Testing the update value assigned to the  instance variable" do
        patch :update, params:{id:article.id,article:subject}
        instanceVariable = assigns(:article)
        article.reload
        expect(article.title).to eq(instanceVariable.title)
      end

    end

  end

  describe "Testing routes for deleting a records" do
    let!(:article){Article.create(title: "Testing delete article",description: "Testing the delete acticle route by providing a id")}
    context "Deleting a record DELETE action - (/articles/id)" do

      it "On successful deletion, it should redirect to the index page" do
        delete :destroy, params:{id:article.id}
        expect(response).to redirect_to(articles_path)
      end

      it "Should flash notification" do
        delete :destroy, params:{id:article.id}
        expect(flash[:notice]).to eq("Article was successfully destroyed.")
      end
    end

  end



end

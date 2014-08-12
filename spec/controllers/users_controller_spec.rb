require 'spec_helper'


describe UsersController do

  before {
    @user = FactoryGirl.build(:user)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WeeksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET index' do
    it 'assigns users as @user' do
      @user.save!
      get :index, {}, valid_session
      assigns(:users).should eq([@user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      @user.save!
      get :show, {:id => @user.to_param}, valid_session
      assigns(:user).should eq(@user)
    end

  end

  describe 'GET new' do
    it 'assigns a new user as @user' do
      get :new, {}, valid_session
      assigns(:user).should be_a_new(User)
    end
  end


  describe 'POST create' do

    context 'with valid attr' do
      it 'creates a new user' do
        expect {
          post :create, {:user => @user.attributes.merge(password: 'foobar' ) }
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as User' do
        post :create, { :user => @user.attributes.merge(password: 'foobar' ) }
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it 'redirects to the created user' do
        post :create, {:user => @user.attributes.merge(password: 'foobar' )  }
        response.should redirect_to(user_url(User.first.id))
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved user as user' do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { 'name' => 'invalid value'}}
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { 'name' => 'invalid value'}}
        response.should render_template('new')
      end
    end
  end

end

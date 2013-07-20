# encoding: UTF-8

require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "search" do
 
    describe "as a logged user" do
      let(:user) { FactoryGirl.create(:user) }
    
      before(:each) do
        sign_in user
        visit users_path
      end

      before { click_button "buscar" }

      it { should have_selector('title', text: 'Buscar usuarios') }
      it { should have_selector('h1', text: 'Resultados de la búsqueda') }
    end

    describe "as a non logged user" do
    
      before(:each) do
        visit root_path
      end

      it { should_not have_button "buscar" }
    end
  end

  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'Usuarios') }
    it { should have_selector('h1',    text: 'Usuarios') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do

      it { should_not have_link('Borrar') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('Borrar', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('Borrar') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('Borrar', href: user_path(admin)) }
      end
    end

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end
 
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Crear mi cuenta" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Registro - Usuarios') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Nombre",                 with: "Example User"
        fill_in "Email",                  with: "user@example.com"
        fill_in "Contraseña",             with: "foobar"
        fill_in "Repita contraseña",      with: "foobar"
        fill_in "Ciudad de residencia",   with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: '¡Bienvenido a TouristFriend!') }
        it { should have_link('Cerrar sesión') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Actualiza tu perfil") }
      it { should have_selector('title', text: "Editar usuario") }
      it { should have_link('Cambiar imagen', href: 'http://es.gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Guardar cambios" }

      it { should have_content('error') }
    end
 
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:new_ciudad) { "foobar" }
      before do
        fill_in "Nombre",               with: new_name
        fill_in "Email",                with: new_email
        fill_in "Contraseña",           with: user.password
        fill_in "Repita contraseña",    with: user.password
        fill_in "Ciudad de residencia", with: new_ciudad
        click_button "Guardar cambios"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Cerrar sesión', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
      specify { user.reload.ciudad_residencia.should == new_ciudad }
    end
  end
end

# encoding: UTF-8
require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Iniciar sesión') }
    it { should have_selector('title', text: 'Iniciar sesión') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Iniciar sesión" }

      it { should have_selector('title', text: 'Iniciar sesión') }
      it { should have_error_message('inválidos') }

      describe "after visiting another page" do
        before { click_link "Inicio" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }
      
      it { should have_link('Usuarios',    href: users_path) }
      it { should have_link('Perfil',      href: user_path(user)) }
      it { should have_link('Configuración', href: edit_user_path(user)) }
      it { should have_link('Cerrar sesión', href: signout_path) }
      
      it { should_not have_link('Iniciar sesión', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Cerrar sesión" }
        it { should have_link('Iniciar sesión') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Contraseña", with: user.password
          click_button "Iniciar sesión"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Editar usuario')
          end
       
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Contraseña", with: user.password
              click_button "Iniciar sesión"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Iniciar sesión') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Iniciar sesión') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Editar usuario')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end

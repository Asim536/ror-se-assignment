require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @employee_params = { name: 'Employee 1', position: 'ROR Developer', date_of_birth: '2000-01-01', salary: 10000 }
  end

  def test_index
    get :index
    assert_response :success
    assert_template :index
  end

  def test_show
    get :show, params: { id: "1" }
    assert_response :success
    assert_template :show
  end

  def test_edit
    get :edit, params: { id: "1" }
    assert_response :success
    assert_template :edit
  end

  def test_create_success
    EmployeeService.stubs(:create).returns({ 'id' => 1 })

    post :create, params: @employee_params
    assert_redirected_to employee_path(1)
  end

  def test_update_success
    EmployeeService.stubs(:update).returns({ 'id' => 1 })

    patch :update, params: { id: "1" }.merge(@employee_params)
    assert_redirected_to edit_employee_path(1)
  end
end

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[show edit]
  before_action :employee_params, only: %i[create update]

  def index
    @employees = EmployeeService.fetch_all(page: params[:page])
  end

  def show; end

  def edit; end

  def create
    @employee = EmployeeService.create(employee_params)
    handle_response(@employee, employee_path(@employee['id']), :new)
  end

  def update
    @employee = EmployeeService.update(params[:id], employee_params)
    handle_response(@employee, edit_employee_path(@employee['id']), :edit)
  end

  private

  def set_employee
    @employee = EmployeeService.fetch(params[:id])
  end

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end

  def handle_response(employee, success_redirect, error_template)
    if employee['error'].blank?
      redirect_to success_redirect
    else
      render error_template, alert: employee['error']
    end
  end
end
